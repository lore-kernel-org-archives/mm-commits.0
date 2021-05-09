Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9CBC433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B000F61430
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEIDuC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhEIDuC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:50:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0FE96142B;
        Sun,  9 May 2021 03:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620532140;
        bh=+WjJZUAh1PwbPvsFgldIPKyrPSgetppRsYURb/wAYdM=;
        h=Date:From:To:Subject:From;
        b=VX/VHKU4cXHuoIYaIaK8UKvnFM/OUYYVjpN4QZavgLz63WazDQ7rA+lHivQ8zL27B
         Oj3Lq1TQ2fR/659gk+Nhzqiffn/o8k0nTbpOZrbc/5tZfDQvjh282+Sf8SWqHpnjO/
         dMy1j0acn4M4fa1LJer5lR67XwFZ4rTcJNmJFP48=
Date:   Sat, 08 May 2021 20:48:59 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  + seq_file-drop-unused-_escape_mem_ascii.patch added to
 -mm tree
Message-ID: <20210509034859.0ha-tlG1a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: drop unused *_escape_mem_ascii()
has been added to the -mm tree.  Its filename is
     seq_file-drop-unused-_escape_mem_ascii.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/seq_file-drop-unused-_escape_=
mem_ascii.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/seq_file-drop-unused-_escape_=
mem_ascii.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: seq_file: drop unused *_escape_mem_ascii()

There are no more users of the=C2=A0seq_escape_mem_ascii() followed by
string_escape_mem_ascii().

Remove them for good.

Link: https://lkml.kernel.org/r/20210504180819.73127-16-andriy.shevchenko@l=
inux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c                  |   11 -----------
 include/linux/seq_file.h       |    1 -
 include/linux/string_helpers.h |    3 ---
 lib/string_helpers.c           |   19 -------------------
 4 files changed, 34 deletions(-)

--- a/fs/seq_file.c~seq_file-drop-unused-_escape_mem_ascii
+++ a/fs/seq_file.c
@@ -396,17 +396,6 @@ void seq_escape(struct seq_file *m, cons
 }
 EXPORT_SYMBOL(seq_escape);
=20
-void seq_escape_mem_ascii(struct seq_file *m, const char *src, size_t isz)
-{
-	char *buf;
-	size_t size =3D seq_get_buf(m, &buf);
-	int ret;
-
-	ret =3D string_escape_mem_ascii(src, isz, buf, size);
-	seq_commit(m, ret < size ? ret : -1);
-}
-EXPORT_SYMBOL(seq_escape_mem_ascii);
-
 void seq_vprintf(struct seq_file *m, const char *f, va_list args)
 {
 	int len;
--- a/include/linux/seq_file.h~seq_file-drop-unused-_escape_mem_ascii
+++ a/include/linux/seq_file.h
@@ -136,7 +136,6 @@ static inline void seq_escape_str(struct
 }
=20
 void seq_escape(struct seq_file *m, const char *s, const char *esc);
-void seq_escape_mem_ascii(struct seq_file *m, const char *src, size_t isz);
=20
 void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_t=
ype,
 		  int rowsize, int groupsize, const void *buf, size_t len,
--- a/include/linux/string_helpers.h~seq_file-drop-unused-_escape_mem_ascii
+++ a/include/linux/string_helpers.h
@@ -63,9 +63,6 @@ static inline int string_unescape_any_in
 int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
 		unsigned int flags, const char *only);
=20
-int string_escape_mem_ascii(const char *src, size_t isz, char *dst,
-					size_t osz);
-
 static inline int string_escape_mem_any_np(const char *src, size_t isz,
 		char *dst, size_t osz, const char *only)
 {
--- a/lib/string_helpers.c~seq_file-drop-unused-_escape_mem_ascii
+++ a/lib/string_helpers.c
@@ -582,25 +582,6 @@ int string_escape_mem(const char *src, s
 }
 EXPORT_SYMBOL(string_escape_mem);
=20
-int string_escape_mem_ascii(const char *src, size_t isz, char *dst,
-					size_t osz)
-{
-	char *p =3D dst;
-	char *end =3D p + osz;
-
-	while (isz--) {
-		unsigned char c =3D *src++;
-
-		if (!isprint(c) || !isascii(c) || c =3D=3D '"' || c =3D=3D '\\')
-			escape_hex(c, &p, end);
-		else
-			escape_passthrough(c, &p, end);
-	}
-
-	return p - dst;
-}
-EXPORT_SYMBOL(string_escape_mem_ascii);
-
 /*
  * Return an allocated string that has been escaped of special characters
  * and double quotes, making it safe to log in quotes.
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.=
com are

lib-string_helpers-switch-to-use-bit-macro.patch
lib-string_helpers-move-escape_np-check-inside-else-branch-in-a-loop.patch
lib-string_helpers-drop-indentation-level-in-string_escape_mem.patch
lib-string_helpers-introduce-escape_na-for-escaping-non-ascii.patch
lib-string_helpers-introduce-escape_nap-to-escape-non-ascii-and-non-printab=
le.patch
lib-string_helpers-allow-to-append-additional-characters-to-be-escaped.patch
lib-test-string_helpers-print-flags-in-hexadecimal-format.patch
lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch
lib-test-string_helpers-add-test-cases-for-new-features.patch
maintainers-add-myself-as-designated-reviewer-for-generic-string-library.pa=
tch
seq_file-introduce-seq_escape_mem.patch
seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch
seq_file-convert-seq_escape-to-use-seq_escape_str.patch
nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch
seq_file-drop-unused-_escape_mem_ascii.patch

