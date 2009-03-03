From: akpm@linux-foundation.org
Subject: + hppfs-hppfs_read_file-may-return-error.patch added to -mm tree
Date: Tue, 03 Mar 2009 13:23:26 -0800
Message-ID: <200903032123.n23LNQ4q005029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786AbZCCVXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 16:23:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com


The patch titled
     hppfs: hppfs_read_file() may return -ERROR
has been added to the -mm tree.  Its filename is
     hppfs-hppfs_read_file-may-return-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hppfs: hppfs_read_file() may return -ERROR
From: Roel Kluin <roel.kluin@gmail.com>

hppfs_read_file() may return (ssize_t) -ENOMEM, or -EFAULT.  When stored
in size_t 'count', these errors will not be noticed, a large value will be
added to *ppos.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hppfs/hppfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/hppfs/hppfs.c~hppfs-hppfs_read_file-may-return-error fs/hppfs/hppfs.c
--- a/fs/hppfs/hppfs.c~hppfs-hppfs_read_file-may-return-error
+++ a/fs/hppfs/hppfs.c
@@ -280,7 +280,12 @@ static ssize_t hppfs_read(struct file *f
 			       "errno = %d\n", err);
 			return err;
 		}
-		count = hppfs_read_file(hppfs->host_fd, buf, count);
+		err = hppfs_read_file(hppfs->host_fd, buf, count);
+		if (err < 0) {
+			printk(KERN_ERR "hppfs_read: read failed: %d\n", err);
+			return err;
+		}
+		count = err;
 		if (count > 0)
 			*ppos += count;
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
mm-get_nid_for_pfn-returns-int.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
acpi-wmic-unsigned-cannot-be-less-than-0.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
jffs2_acl_count-tests-0-on-unsigned.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
watchdog-fsl_get_sys_freq-failure-not-noticed.patch
hugetlb-chg-cannot-become-less-than-0.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
rtc-test-before-subtraction-on-unsigned.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch
rio-addition-has-higher-precedence-than.patch
aoe-error-printed-1-too-early.patch

