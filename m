From: akpm@osdl.org
Subject: + raw-dont-allow-the-creation-of-a-raw-device-with-minor-number-0.patch added to -mm tree
Date: Fri, 12 Jan 2007 13:26:52 -0800
Message-ID: <200701122126.l0CLQqlp029388@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161085AbXALV1D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 16:27:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com, sfernand@redhat.com


The patch titled
     raw: don't allow the creation of a raw device with minor number 0
has been added to the -mm tree.  Its filename is
     raw-dont-allow-the-creation-of-a-raw-device-with-minor-number-0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: raw: don't allow the creation of a raw device with minor number 0
From: Jeff Moyer <jmoyer@redhat.com>

Minor number 0 (under the raw major) is reserved for the rawctl device
file, which is used to query, set, and unset raw device bindings.  However,
the ioctl interface does not protect the user from specifying a raw device
with minor number 0:

$ sudo ./raw /dev/raw/raw0 /dev/VolGroup00/swap
/dev/raw/raw0:  bound to major 253, minor 2
$ ls -l /dev/rawctl
ls: /dev/rawctl: No such file or directory
$ ls -l /dev/raw/raw0
crw------- 1 root root 162, 0 Jan 12 10:51 /dev/raw/raw0
$ sudo ./raw -qa
Cannot open master raw device '/dev/rawctl' (No such file or directory)

As you can see, this prevents any further raw operations from
succeeding.  The fix (from Steve Fernandez) is quite simple--do not
allow the allocation of minor number 0.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Steven Fernandez <sfernand@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/raw.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/raw.c~raw-dont-allow-the-creation-of-a-raw-device-with-minor-number-0 drivers/char/raw.c
--- a/drivers/char/raw.c~raw-dont-allow-the-creation-of-a-raw-device-with-minor-number-0
+++ a/drivers/char/raw.c
@@ -154,7 +154,7 @@ static int raw_ctl_ioctl(struct inode *i
 			goto out;
 		}
 
-		if (rq.raw_minor < 0 || rq.raw_minor >= MAX_RAW_MINORS) {
+		if (rq.raw_minor <= 0 || rq.raw_minor >= MAX_RAW_MINORS) {
 			err = -EINVAL;
 			goto out;
 		}
_

Patches currently in -mm which might be from jmoyer@redhat.com are

raw-dont-allow-the-creation-of-a-raw-device-with-minor-number-0.patch
