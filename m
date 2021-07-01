Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25ED7C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1425B61469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238553AbhGAB6R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238552AbhGAB6Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11E3A61418;
        Thu,  1 Jul 2021 01:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104547;
        bh=PwC8MUotYe9y0h9hrqnU8rpMllTzEKvYhoIsN9UEDtc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BZ0dnP3JAV7v/jImvJpSqo/Fxt+0TFbx3SWLK3trDzJ+I4BGjJ9yKGKwYfkBWVb4e
         GrPzO308/0BdMmqshbFm93HrGJScHRFHOTgg0gFLlVNGom5iRagijYMvyEawuyATT7
         4yT9SzSlKNlebeSiDfwE14nUtb6tpFzmpjIGYkos=
Date:   Wed, 30 Jun 2021 18:55:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 162/192] seq_file: drop unused
 *_escape_mem_ascii()
Message-ID: <20210701015546.-G-crt14P%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
