From: akpm@linux-foundation.org
Subject: + hfsplus-fix-remount-issue.patch added to -mm tree
Date: Wed, 26 Feb 2014 14:57:35 -0800
Message-ID: <530e715f.K2OAl/qubwvGqIp5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaBZW5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 17:57:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-fix-remount-issue.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 14:57:35 -0800


The patch titled
     Subject: hfsplus: fix remount issue
has been added to the -mm tree.  Its filename is
     hfsplus-fix-remount-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-fix-remount-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-fix-remount-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: fix remount issue

Current implementation of HFS+ driver has small issue with remount option.
 Namely, for example, you are unable to remount from RO mode into RW mode
by means of command "mount -o remount,rw /dev/loop0 /mnt/hfsplus".  Trying
to execute sequence of commands results in an error message:

mount /dev/loop0 /mnt/hfsplus
mount -o remount,ro /dev/loop0 /mnt/hfsplus
mount -o remount,rw /dev/loop0 /mnt/hfsplus

mount: you must specify the filesystem type

mount -t hfsplus -o remount,rw /dev/loop0 /mnt/hfsplus

mount: /mnt/hfsplus not mounted or bad option

The reason of such issue is failure of mount syscall:

mount("/dev/loop0", "/mnt/hfsplus", 0x2282a60, MS_MGC_VAL|MS_REMOUNT, NULL) = -1 EINVAL (Invalid argument)

Namely, hfsplus_parse_options_remount() method receives empty "input"
argument and return false in such case.  As a result, hfsplus_remount()
returns -EINVAL error code.

This patch fixes the issue by means of return true for the case of empty
"input" argument in hfsplus_parse_options_remount() method.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/options.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/options.c~hfsplus-fix-remount-issue fs/hfsplus/options.c
--- a/fs/hfsplus/options.c~hfsplus-fix-remount-issue
+++ a/fs/hfsplus/options.c
@@ -75,7 +75,7 @@ int hfsplus_parse_options_remount(char *
 	int token;
 
 	if (!input)
-		return 0;
+		return 1;
 
 	while ((p = strsep(&input, ",")) != NULL) {
 		if (!*p)
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-fix-remount-issue.patch
hfsplus-add-hfsx-subfolder-count-support.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
hfsplus-fix-longname-handling.patch

