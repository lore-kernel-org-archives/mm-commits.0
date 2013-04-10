From: akpm@linux-foundation.org
Subject: + fs-dcachec-add-cond_resched-to-shrink_dcache_parent.patch added to -mm tree
Date: Wed, 10 Apr 2013 16:45:06 -0700
Message-ID: <20130410234506.A28BD5A42B8@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:59975 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934578Ab3DJXpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 19:45:08 -0400
Received: by mail-ie0-f202.google.com with SMTP id x12so171456ief.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 16:45:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, david@fromorbit.com, stable@kernel.org


The patch titled
     Subject: fs/dcache.c: add cond_resched() to shrink_dcache_parent()
has been added to the -mm tree.  Its filename is
     fs-dcachec-add-cond_resched-to-shrink_dcache_parent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: fs/dcache.c: add cond_resched() to shrink_dcache_parent()

Call cond_resched() in shrink_dcache_parent() to maintain interactivity.

Before this patch:

void shrink_dcache_parent(struct dentry * parent)
{
	while ((found = select_parent(parent, &dispose)) != 0)
		shrink_dentry_list(&dispose);
}

select_parent() populates the dispose list with dentries which
shrink_dentry_list() then deletes.  select_parent() carefully uses
need_resched() to avoid doing too much work at once.  But neither
shrink_dcache_parent() nor its called functions call cond_resched().  So
once need_resched() is set select_parent() will return single dentry
dispose list which is then deleted by shrink_dentry_list().  This is
inefficient when there are a lot of dentry to process.  This can cause
softlockup and hurts interactivity on non preemptable kernels.

This change adds cond_resched() in shrink_dcache_parent().  The benefit of
this is that need_resched() is quickly cleared so that future calls to
select_parent() are able to efficiently return a big batch of dentry.

These additional cond_resched() do not seem to impact performance, at
least for the workload below.

Here is a program which can cause soft lockup if other system activity
sets need_resched().

	int main()
	{
	        struct rlimit rlim;
	        int i;
	        int f[100000];
	        char buf[20];
	        struct timeval t1, t2;
	        double diff;

	        /* cleanup past run */
	        system("rm -rf x");

	        /* boost nfile rlimit */
	        rlim.rlim_cur = 200000;
	        rlim.rlim_max = 200000;
	        if (setrlimit(RLIMIT_NOFILE, &rlim))
	                err(1, "setrlimit");

	        /* make directory for files */
	        if (mkdir("x", 0700))
	                err(1, "mkdir");

	        if (gettimeofday(&t1, NULL))
	                err(1, "gettimeofday");

	        /* populate directory with open files */
	        for (i = 0; i < 100000; i++) {
	                snprintf(buf, sizeof(buf), "x/%d", i);
	                f[i] = open(buf, O_CREAT);
	                if (f[i] == -1)
	                        err(1, "open");
	        }

	        /* close some of the files */
	        for (i = 0; i < 85000; i++)
	                close(f[i]);

	        /* unlink all files, even open ones */
	        system("rm -rf x");

	        if (gettimeofday(&t2, NULL))
	                err(1, "gettimeofday");

	        diff = (((double)t2.tv_sec * 1000000 + t2.tv_usec) -
	                ((double)t1.tv_sec * 1000000 + t1.tv_usec));

	        printf("done: %g elapsed\n", diff/1e6);
	        return 0;
	}

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/dcache.c~fs-dcachec-add-cond_resched-to-shrink_dcache_parent fs/dcache.c
--- a/fs/dcache.c~fs-dcachec-add-cond_resched-to-shrink_dcache_parent
+++ a/fs/dcache.c
@@ -1230,8 +1230,10 @@ void shrink_dcache_parent(struct dentry
 	LIST_HEAD(dispose);
 	int found;
 
-	while ((found = select_parent(parent, &dispose)) != 0)
+	while ((found = select_parent(parent, &dispose)) != 0) {
 		shrink_dentry_list(&dispose);
+		cond_resched();
+	}
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
_

Patches currently in -mm which might be from gthelen@google.com are

fs-dcachec-add-cond_resched-to-shrink_dcache_parent.patch

