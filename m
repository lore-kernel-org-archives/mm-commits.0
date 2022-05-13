Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17764C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354110AbiEMT15 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383942AbiEMT0A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:26:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF1E387A2
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:23:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECF10615DC
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A94EC34100;
        Fri, 13 May 2022 19:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469818;
        bh=BNr8OAD6O5CNyPwYepnurYHeqSioBHEjyE16ylMrnjU=;
        h=Date:To:From:Subject:From;
        b=g0LVMVf6bNIgZmgWit22/xSLncttScxGeTuqpcSnFMlPt9oP77j9AHZhSiqgwFK/A
         J4Ttd/OhnlLuky16wZluFVc+lTSubCgG1wc//MQvUfyXpQDfSNzotPB+a/GZ1eo23o
         wzkiO2FEphZNjoMe8Ic+6p/0P0gfAgQIdL1EEyYM=
Date:   Fri, 13 May 2022 12:23:37 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        ebiederm@xmission.com, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] elf-uapi-fixup-elf_st_type-definition.patch removed from -mm tree
Message-Id: <20220513192338.4A94EC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ELF, uapi: fixup ELF_ST_TYPE definition
has been removed from the -mm tree.  Its filename was
     elf-uapi-fixup-elf_st_type-definition.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ELF, uapi: fixup ELF_ST_TYPE definition

This is very theoretical compile failure:

	ELF_ST_TYPE(st_info = A)

Cast will bind first and st_info will stop being lvalue:

	error: lvalue required as left operand of assignment

Given that the only use of this macro is

	ELF_ST_TYPE(sym->st_info)

where st_info is "unsigned char" I've decided to remove cast especially
given that companion macro ELF_ST_BIND doesn't use cast.

Link: https://lkml.kernel.org/r/Ymv7G1BeX4kt3obz@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/elf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/elf.h~elf-uapi-fixup-elf_st_type-definition
+++ a/include/uapi/linux/elf.h
@@ -134,7 +134,7 @@ typedef __s64	Elf64_Sxword;
 #define STT_TLS     6
 
 #define ELF_ST_BIND(x)		((x) >> 4)
-#define ELF_ST_TYPE(x)		(((unsigned int) x) & 0xf)
+#define ELF_ST_TYPE(x)		((x) & 0xf)
 #define ELF32_ST_BIND(x)	ELF_ST_BIND(x)
 #define ELF32_ST_TYPE(x)	ELF_ST_TYPE(x)
 #define ELF64_ST_BIND(x)	ELF_ST_BIND(x)
_

Patches currently in -mm which might be from adobriyan@gmail.com are


