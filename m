From: akpm@linux-foundation.org
Subject: + modpost-simplify-sec_name.patch added to -mm tree
Date: Wed, 09 Aug 2017 13:35:57 -0700
Message-ID: <598b722d.WBEpNbEAZt6NPuef%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752166AbdHIUgM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2017 16:36:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, ard.biesheuvel@linaro.org, cmetcalf@mellanox.com, jeyu@redhat.com, keescook@chromium.org, mingo@kernel.org, npiggin@gmail.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: modpost: simplify sec_name()
has been added to the -mm tree.  Its filename is
     modpost-simplify-sec_name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/modpost-simplify-sec_name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/modpost-simplify-sec_name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
