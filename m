From: akpm@linux-foundation.org
Subject: + kthread-add-__printf-attributes.patch added to -mm tree
Date: Wed, 30 Nov 2016 14:27:59 -0800
Message-ID: <583f526f.ZqFZ1nDP2giAjnH0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36140 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753078AbcK3W1n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 17:27:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, pmladek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: add __printf attributes
has been added to the -mm tree.  Its filename is
     kthread-add-__printf-attributes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread-add-__printf-attributes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread-add-__printf-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: kthread: add __printf attributes

When commit fbae2d44aa1d ("kthread: add kthread_create_worker*()")
introduced some kthread_create_...() functions which were taking
printf-like parametter, it introduced __printf attributes to some
functions (e.g.  kthread_create_worker()).  Nevertheless some new
functions were forgotten (they have been detected thanks to
-Wmissing-format-attribute warning flag).

Add the missing __printf attributes to the newly-introduced functions in
order to detect formatting issues at build-time with -Wformat flag.

Link: http://lkml.kernel.org/r/20161126193543.22672-1-nicolas.iooss_linux@m4x.org
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    2 +-
 kernel/kthread.c        |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/kthread.h~kthread-add-__printf-attributes include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-add-__printf-attributes
+++ a/include/linux/kthread.h
@@ -174,7 +174,7 @@ __printf(2, 3)
 struct kthread_worker *
 kthread_create_worker(unsigned int flags, const char namefmt[], ...);
 
-struct kthread_worker *
+__printf(3, 4) struct kthread_worker *
 kthread_create_worker_on_cpu(int cpu, unsigned int flags,
 			     const char namefmt[], ...);
 
diff -puN kernel/kthread.c~kthread-add-__printf-attributes kernel/kthread.c
--- a/kernel/kthread.c~kthread-add-__printf-attributes
+++ a/kernel/kthread.c
@@ -244,7 +244,8 @@ static void create_kthread(struct kthrea
 	}
 }
 
-static struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
+static __printf(4, 0)
+struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
 						    void *data, int node,
 						    const char namefmt[],
 						    va_list args)
@@ -630,7 +631,7 @@ repeat:
 }
 EXPORT_SYMBOL_GPL(kthread_worker_fn);
 
-static struct kthread_worker *
+static __printf(3, 0) struct kthread_worker *
 __kthread_create_worker(int cpu, unsigned int flags,
 			const char namefmt[], va_list args)
 {
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.org are

kthread-add-__printf-attributes.patch

