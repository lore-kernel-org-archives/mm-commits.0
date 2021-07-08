Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B5CC07E9B
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF8A861CDA
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhGHBLy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230228AbhGHBLw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:11:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A49661CD5;
        Thu,  8 Jul 2021 01:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706551;
        bh=8vgIKmTXBjM7UfNVr31V5kmE/YaqGxTY7Xk5DG+AEOk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Yi9PEF/9HUS7RtKvIghcdHj090Cl4dK1ClSNiH61sc4ukGI5C4EuyoAoZrFnNgS18
         pK/rjw6cAouWU3nb3zyHBXPbk/mPKjDERhz11VVOmFXQITy532RTSUua3ecmqe3Xmq
         F/v7BEG1jdJ28+iyVF+Vk/+nzA6qhJYYokZiSxlQ=
Date:   Wed, 07 Jul 2021 18:09:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        ast@kernel.org, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dyoung@redhat.com, evgreen@chromium.org,
        hsinyi@chromium.org, jeyu@kernel.org, jolsa@kernel.org,
        khlebnikov@yandex-team.ru, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sashal@kernel.org, sergey.senozhatsky@gmail.com,
        swboyd@chromium.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com, will@kernel.org,
        willy@infradead.org
Subject:  [patch 32/54] buildid: add API to parse build ID out of
 buffer
Message-ID: <20210708010910.ogVraL56P%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>
Subject: buildid: add API to parse build ID out of buffer

Add an API that can parse the build ID out of a buffer, instead of a vma,
to support printing a kernel module's build ID for stack traces.

Link: https://lkml.kernel.org/r/20210511003845.2429846-3-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buildid.h |    1 
 lib/buildid.c           |   50 ++++++++++++++++++++++++++++----------
 2 files changed, 38 insertions(+), 13 deletions(-)

--- a/include/linux/buildid.h~buildid-add-api-to-parse-build-id-out-of-buffer
+++ a/include/linux/buildid.h
@@ -8,5 +8,6 @@
 
 int build_id_parse(struct vm_area_struct *vma, unsigned char *build_id,
 		   __u32 *size);
+int build_id_parse_buf(const void *buf, unsigned char *build_id, u32 buf_size);
 
 #endif
--- a/lib/buildid.c~buildid-add-api-to-parse-build-id-out-of-buffer
+++ a/lib/buildid.c
@@ -2,30 +2,23 @@
 
 #include <linux/buildid.h>
 #include <linux/elf.h>
+#include <linux/kernel.h>
 #include <linux/pagemap.h>
 
 #define BUILD_ID 3
+
 /*
  * Parse build id from the note segment. This logic can be shared between
  * 32-bit and 64-bit system, because Elf32_Nhdr and Elf64_Nhdr are
  * identical.
  */
-static inline int parse_build_id(void *page_addr,
-				 unsigned char *build_id,
-				 __u32 *size,
-				 void *note_start,
-				 Elf32_Word note_size)
+static int parse_build_id_buf(unsigned char *build_id,
+			      __u32 *size,
+			      const void *note_start,
+			      Elf32_Word note_size)
 {
 	Elf32_Word note_offs = 0, new_offs;
 
-	/* check for overflow */
-	if (note_start < page_addr || note_start + note_size < note_start)
-		return -EINVAL;
-
-	/* only supports note that fits in the first page */
-	if (note_start + note_size > page_addr + PAGE_SIZE)
-		return -EINVAL;
-
 	while (note_offs + sizeof(Elf32_Nhdr) < note_size) {
 		Elf32_Nhdr *nhdr = (Elf32_Nhdr *)(note_start + note_offs);
 
@@ -50,9 +43,27 @@ static inline int parse_build_id(void *p
 			break;
 		note_offs = new_offs;
 	}
+
 	return -EINVAL;
 }
 
+static inline int parse_build_id(void *page_addr,
+				 unsigned char *build_id,
+				 __u32 *size,
+				 void *note_start,
+				 Elf32_Word note_size)
+{
+	/* check for overflow */
+	if (note_start < page_addr || note_start + note_size < note_start)
+		return -EINVAL;
+
+	/* only supports note that fits in the first page */
+	if (note_start + note_size > page_addr + PAGE_SIZE)
+		return -EINVAL;
+
+	return parse_build_id_buf(build_id, size, note_start, note_size);
+}
+
 /* Parse build ID from 32-bit ELF */
 static int get_build_id_32(void *page_addr, unsigned char *build_id,
 			   __u32 *size)
@@ -148,3 +159,16 @@ out:
 	put_page(page);
 	return ret;
 }
+
+/**
+ * build_id_parse_buf - Get build ID from a buffer
+ * @buf:      Elf note section(s) to parse
+ * @buf_size: Size of @buf in bytes
+ * @build_id: Build ID parsed from @buf, at least BUILD_ID_SIZE_MAX long
+ *
+ * Return: 0 on success, -EINVAL otherwise
+ */
+int build_id_parse_buf(const void *buf, unsigned char *build_id, u32 buf_size)
+{
+	return parse_build_id_buf(build_id, NULL, buf, buf_size);
+}
_
