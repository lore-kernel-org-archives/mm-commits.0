From: akpm@linux-foundation.org
Subject: [patch 010/119] modpost: simplify sec_name()
Date: Wed, 06 Sep 2017 16:19:05 -0700
Message-ID: <20170906231905.vAvubXPgp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49132 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754578AbdIFXTG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:19:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, cmetcalf@mellanox.com, jeyu@redhat.com, keescook@chromium.org, mingo@kernel.org, mm-commits@vger.kernel.org, npiggin@gmail.com, torvalds@linux-foundation.org, xypron.glpk@gmx.de, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: modpost: simplify sec_name()

There is code duplication between sec_name() and sech_name().  Simplify
sec_name() by re-using sech_name().  Also, move them up to remove the
forward declaration of sec_name().

Link: http://lkml.kernel.org/r/1502248721-22009-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff -puN scripts/mod/modpost.c~modpost-simplify-sec_name scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~modpost-simplify-sec_name
+++ a/scripts/mod/modpost.c
@@ -261,7 +261,17 @@ static enum export export_no(const char
 	return export_unknown;
 }
 
-static const char *sec_name(struct elf_info *elf, int secindex);
+static const char *sech_name(struct elf_info *elf, Elf_Shdr *sechdr)
+{
+	return (void *)elf->hdr +
+		elf->sechdrs[elf->secindex_strings].sh_offset +
+		sechdr->sh_name;
+}
+
+static const char *sec_name(struct elf_info *elf, int secindex)
+{
+	return sech_name(elf, &elf->sechdrs[secindex]);
+}
 
 #define strstarts(str, prefix) (strncmp(str, prefix, strlen(prefix)) == 0)
 
@@ -775,21 +785,6 @@ static const char *sym_name(struct elf_i
 		return "(unknown)";
 }
 
-static const char *sec_name(struct elf_info *elf, int secindex)
-{
-	Elf_Shdr *sechdrs = elf->sechdrs;
-	return (void *)elf->hdr +
-		elf->sechdrs[elf->secindex_strings].sh_offset +
-		sechdrs[secindex].sh_name;
-}
-
-static const char *sech_name(struct elf_info *elf, Elf_Shdr *sechdr)
-{
-	return (void *)elf->hdr +
-		elf->sechdrs[elf->secindex_strings].sh_offset +
-		sechdr->sh_name;
-}
