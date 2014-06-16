From: akpm@linux-foundation.org
Subject: [alternative-merged]
 x86-vdso-remove-one-final-use-of-htole16.patch removed from -mm tree
Date: Mon, 16 Jun 2014 12:04:51 -0700
Message-ID: <539f3fd3.wugSpvhb14mPdycO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaFPTEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 15:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, luto@amacapital.net, akpm@linux-foundation.org, hpa@zytor.com

Subject: [alternative-merged] x86-vdso-remove-one-final-use-of-htole16.patch removed from -mm tree
To: hpa@zytor.com,akpm@linux-foundation.org,luto@amacapital.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Jun 2014 12:04:51 -0700


The patch titled
     Subject: x86, vdso: Remove one final use of htole16()
has been removed from the -mm tree.  Its filename was
     x86-vdso-remove-one-final-use-of-htole16.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: x86, vdso: Remove one final use of htole16()

One final use of the macros from <endian.h> which are not available on
older system.  In this case we had one sole case of *writing* a
littleendian number, but the number is SHN_UNDEF which is the constant
zero, so rather than dealing with the general case of littleendian puts
here, just document that the constant is zero and be done with it.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/20140610135051.c3c34165f73d67d218b62bd9@linux-foundation.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vdso2c.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/vdso/vdso2c.h~x86-vdso-remove-one-final-use-of-htole16 arch/x86/vdso/vdso2c.h
--- a/arch/x86/vdso/vdso2c.h~x86-vdso-remove-one-final-use-of-htole16
+++ a/arch/x86/vdso/vdso2c.h
@@ -116,7 +116,7 @@ static void GOFUNC(void *addr, size_t le
 	hdr->e_shoff = 0;
 	hdr->e_shentsize = 0;
 	hdr->e_shnum = 0;
-	hdr->e_shstrndx = htole16(SHN_UNDEF);
+	hdr->e_shstrndx = SHN_UNDEF; /* SHN_UNDEF == 0 */
 
 	if (!name) {
 		fwrite(addr, load_size, 1, outfile);
_

Patches currently in -mm which might be from hpa@zytor.com are

lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch
linux-next.patch

