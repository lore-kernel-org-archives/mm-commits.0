From: akpm@linux-foundation.org
Subject: + fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch
 added to -mm tree
Date: Tue, 11 Jun 2013 15:56:14 -0700
Message-ID: <51b7ab0e.4yGdcHxUxB8E3GXN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3FKW4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com, dan.carpenter@oracle.com

Subject: + fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch added to -mm tree
To: dan.carpenter@oracle.com,dchinner@redhat.com,glommer@openvz.org
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:56:14 -0700


The patch titled
     Subject: UBIFS: signedness bug in ubifs_shrink_count()
has been added to the -mm tree.  Its filename is
     fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: UBIFS: signedness bug in ubifs_shrink_count()

We test "clean_zn_cnt" for negative later in the function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/shrinker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ubifs/shrinker.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix fs/ubifs/shrinker.c
--- a/fs/ubifs/shrinker.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix
+++ a/fs/ubifs/shrinker.c
@@ -280,7 +280,7 @@ static int kick_a_thread(void)
 unsigned long ubifs_shrink_count(struct shrinker *shrink,
 				 struct shrink_control *sc)
 {
-	unsigned long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
+	long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
 
 	/*
 	 * Due to the way UBIFS updates the clean znode counter it may
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
drivers-misc-sgi-gru-grufilec-fix-info-leak-in-gru_get_config_info.patch
fanotify-info-leak-in-copy_event_to_user.patch
configfs-use-capped-length-for-store_attribute.patch
drivers-cdrom-cdromc-use-kzalloc-for-failing-hardware.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch
mm-vmallocc-unbreak-__vunmap.patch
errh-is_err-can-accept-__user-pointers.patch
drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option.patch
rbtree-remove-unneeded-include.patch
rbtree-remove-unneeded-include-fix.patch
minix-bug-widening-a-binary-not-operation.patch
documentation-codingstyle-allow-multiple-return-statements-per-function.patch
mwave-fix-info-leak-in-mwave_ioctl.patch

