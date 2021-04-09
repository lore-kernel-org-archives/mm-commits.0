Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57372C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 01:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2378B610F7
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 01:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhDIBzj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Apr 2021 21:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbhDIBzj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 8 Apr 2021 21:55:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 062FD610CF;
        Fri,  9 Apr 2021 01:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617933327;
        bh=Z45HT0Y7xfyEqXR+BbjUzbfUjJOvSaQtjhy/JlP7eDs=;
        h=Date:From:To:Subject:From;
        b=PjtFob5I5bZHR7ZIJvt7EJ5/14gE6c2yMtSeraB/55KLwKHF0HuSflZkt4s1yzxrj
         sC/MHGVk8h4fyGr6aZTTT5/gqqZ1UtDCW6GLUH2lv4zh1xWt4Qe1y/gZLyDnPmTp61
         7Q5pzUvClunYOFR9KYXe9e9He+26xPgH8ksBsO50=
Date:   Thu, 08 Apr 2021 18:55:26 -0700
From:   akpm@linux-foundation.org
To:     lucjan.lucjanov@gmail.com, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, oleksandr@natalenko.name,
        terrelln@fb.com
Subject:  [obsolete]
 init-add-support-for-zstd-compressed-modules.patch removed from -mm tree
Message-ID: <20210409015526.eWqkOuC_O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: add support for zstd compressed modules
has been removed from the -mm tree.  Its filename was
     init-add-support-for-zstd-compressed-modules.patch

This patch was dropped because it is obsolete

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
Cc: Nick Terrell <terrelln@fb.com>
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


