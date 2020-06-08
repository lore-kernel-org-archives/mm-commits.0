From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 53/54] module: move the set_fs hack for
 flush_icache_range to m68k
Date: Sun, 07 Jun 2020 21:42:52 -0700
Message-ID: <20200608044252.rWXqv-7lb%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEmy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:54 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, geert@linux-m68k.org, hch@lst.de, jeyu@kernel.org, kafai@fb.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, songliubraving@fb.com, torvalds@linux-foundation.org, yhs@fb.com

From: Christoph Hellwig <hch@lst.de>
Subject: module: move the set_fs hack for flush_icache_range to m68k

flush_icache_range generally operates on kernel addresses, but for some
reason m68k needed a set_fs override.  Move that into the m68k code insted
of keeping it in the module loader.

Link: http://lkml.kernel.org/r/20200515143646.3857579-30-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Jessica Yu <jeyu@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/cache.c |    4 ++++
 kernel/module.c      |    8 --------
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/arch/m68k/mm/cache.c~module-move-the-set_fs-hack-for-flush_icache_range-to-m68k
+++ a/arch/m68k/mm/cache.c
@@ -107,7 +107,11 @@ void flush_icache_user_range(unsigned lo
 
 void flush_icache_range(unsigned long address, unsigned long endaddr)
 {
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(KERNEL_DS);
 	flush_icache_user_range(address, endaddr);
+	set_fs(old_fs);
 }
 EXPORT_SYMBOL(flush_icache_range);
 
--- a/kernel/module.c~module-move-the-set_fs-hack-for-flush_icache_range-to-m68k
+++ a/kernel/module.c
@@ -3344,12 +3344,6 @@ static int check_module_license_and_vers
 
 static void flush_module_icache(const struct module *mod)
 {
-	mm_segment_t old_fs;
-
-	/* flush the icache in correct context */
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-
 	/*
 	 * Flush the instruction cache, since we've played with text.
 	 * Do it before processing of module parameters, so the module
@@ -3361,8 +3355,6 @@ static void flush_module_icache(const st
 				   + mod->init_layout.size);
 	flush_icache_range((unsigned long)mod->core_layout.base,
 			   (unsigned long)mod->core_layout.base + mod->core_layout.size);
