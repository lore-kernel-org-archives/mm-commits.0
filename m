From: akpm@linux-foundation.org
Subject: + checkpatch-ignore-__pure-attribute.patch added to -mm tree
Date: Mon, 05 Jan 2015 13:25:38 -0800
Message-ID: <54ab0152.JtGpjK6Tb9hJ2Qcn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbbAEVZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 16:25:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: ignore __pure $Attribute
has been added to the -mm tree.  Its filename is
     checkpatch-ignore-__pure-attribute.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-ignore-__pure-attribute.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-ignore-__pure-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: ignore __pure $Attribute

Just like "__cold", ignore the __pure gcc attribute macro so pointer
warnings aren't generated for uses like "int * __pure fn(...)"

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-ignore-__pure-attribute scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-ignore-__pure-attribute
+++ a/scripts/checkpatch.pl
@@ -278,6 +278,7 @@ our $Attribute	= qr{
 			__noreturn|
 			__used|
 			__cold|
+			__pure|
 			__noclone|
 			__deprecated|
 			__read_mostly|
_

Patches currently in -mm which might be from joe@perches.com are

printk-correct-timeout-comment-neaten-module_parm_desc.patch
mm-utilc-add-kstrimdup.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
checkpatch-improve-octal-permissions-tests.patch
checkpatch-ignore-__pure-attribute.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

