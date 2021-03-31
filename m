Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57291C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22A7161952
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhCaEx3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhCaEx1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:53:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA0F46190A;
        Wed, 31 Mar 2021 04:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617166407;
        bh=qrQ4cAiffK4EdojJSv/jZgFKebgDVSSoxQ/idUK0qFM=;
        h=Date:From:To:Subject:From;
        b=Aq4ejMBoNDxyxnJKOcFFxPz1hvIQsNVqn+BbtlqyZ1nm/Cs7y2PKRMid5THiDA/rN
         O7L1hc1CT0UFcFCdRpo6k5gM4j0gJO2tnvdj0GuGjE1iliXlsjJomCSjDsHapKw/DD
         CBQUF0E41fSiAGtJhay09nDcNJ1+/XVVYQHdtfx4=
Date:   Tue, 30 Mar 2021 21:53:26 -0700
From:   akpm@linux-foundation.org
To:     lucjan.lucjanov@gmail.com, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, oleksandr@natalenko.name
Subject:  + init-add-support-for-zstd-compressed-modules.patch
 added to -mm tree
Message-ID: <20210331045326.9oHKzEL-X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: add support for zstd compressed modules
has been added to the -mm tree.  Its filename is
     init-add-support-for-zstd-compressed-modules.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-add-support-for-zstd-compressed-modules.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-add-support-for-zstd-compressed-modules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Piotr Gorski <lucjan.lucjanov@gmail.com>
Subject: init: add support for zstd compressed modules

kmod 28 supports modules compressed in zstd format so let's add this
possibility to kernel.

Requires this update to mkinitcpio:
https://github.com/archlinux/mkinitcpio/pull/43

Link: https://lkml.kernel.org/r/20210330113235.2767216-1-lucjan.lucjanov@gmail.com
Signed-off-by: Piotr Gorski <lucjan.lucjanov@gmail.com>
Reviewed-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile     |    7 +++++--
 init/Kconfig |    9 ++++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/init/Kconfig~init-add-support-for-zstd-compressed-modules
+++ a/init/Kconfig
@@ -2222,8 +2222,8 @@ config MODULE_COMPRESS
 	bool "Compress modules on installation"
 	help
 
-	  Compresses kernel modules when 'make modules_install' is run; gzip or
-	  xz depending on "Compression algorithm" below.
+	  Compresses kernel modules when 'make modules_install' is run; gzip,
+	  xz, or zstd depending on "Compression algorithm" below.
 
 	  module-init-tools MAY support gzip, and kmod MAY support gzip and xz.
 
@@ -2245,7 +2245,7 @@ choice
 	  This determines which sort of compression will be used during
 	  'make modules_install'.
 
-	  GZIP (default) and XZ are supported.
+	  GZIP (default), XZ, and ZSTD are supported.
 
 config MODULE_COMPRESS_GZIP
 	bool "GZIP"
@@ -2253,6 +2253,9 @@ config MODULE_COMPRESS_GZIP
 config MODULE_COMPRESS_XZ
 	bool "XZ"
 
+config MODULE_COMPRESS_ZSTD
+	bool "ZSTD"
+
 endchoice
 
 config MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS
--- a/Makefile~init-add-support-for-zstd-compressed-modules
+++ a/Makefile
@@ -1066,8 +1066,8 @@ endif # INSTALL_MOD_STRIP
 export mod_strip_cmd
 
 # CONFIG_MODULE_COMPRESS, if defined, will cause module to be compressed
-# after they are installed in agreement with CONFIG_MODULE_COMPRESS_GZIP
-# or CONFIG_MODULE_COMPRESS_XZ.
+# after they are installed in agreement with CONFIG_MODULE_COMPRESS_GZIP,
+# CONFIG_MODULE_COMPRESS_XZ, or CONFIG_MODULE_COMPRESS_ZSTD.
 
 mod_compress_cmd = true
 ifdef CONFIG_MODULE_COMPRESS
@@ -1077,6 +1077,9 @@ ifdef CONFIG_MODULE_COMPRESS
   ifdef CONFIG_MODULE_COMPRESS_XZ
     mod_compress_cmd = $(XZ) --lzma2=dict=2MiB -f
   endif # CONFIG_MODULE_COMPRESS_XZ
+  ifdef CONFIG_MODULE_COMPRESS_ZSTD
+    mod_compress_cmd = $(ZSTD) -T0 --rm -f -q
+  endif # CONFIG_MODULE_COMPRESS_ZSTD
 endif # CONFIG_MODULE_COMPRESS
 export mod_compress_cmd
 
_

Patches currently in -mm which might be from lucjan.lucjanov@gmail.com are

init-add-support-for-zstd-compressed-modules.patch

