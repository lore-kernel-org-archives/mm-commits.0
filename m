Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138F5C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348005AbiATVak (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377923AbiATVak (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99010C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:30:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56257B81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9584C340E3;
        Thu, 20 Jan 2022 21:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714237;
        bh=wWVmJXrHMQoIr8QdnYLraRJ+gbs/BLqtU220qF6WiD4=;
        h=Date:From:To:Subject:From;
        b=b0yOa1ZbOuAK5axy+lKukXhQk4wryfxUgKuc+NCGUkxCPFSQDLNxJHcWTXPSEbEIc
         EITx+WQlyji7+Sj88ojy/xpHqf8qYT/WUE/lEHEk5XbwTFPn7Y5JbUV95y0uAkHhhU
         1K7yobY7kAse0HKYC9V2/7+ITwNYxhk0PyjYdaNA=
Date:   Thu, 20 Jan 2022 13:30:36 -0800
From:   akpm@linux-foundation.org
To:     augusto.duraes33@gmail.com, brendanhiggins@google.com,
        davidgow@google.com, dlatypov@google.com, ferreiraenzoa@gmail.com,
        geert@linux-m68k.org, isabbasso@riseup.net, lkp@intel.com,
        mm-commits@vger.kernel.org, rodrigosiqueiramelo@gmail.com,
        skhan@linuxfoundation.org
Subject:  [merged] test_hashc-split-test_hash_init.patch removed
 from -mm tree
Message-ID: <20220120213036.AzybBaupL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: test_hash.c: split test_hash_init
has been removed from the -mm tree.  Its filename was
     test_hashc-split-test_hash_init.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Isabella Basso <isabbasso@riseup.net>
Subject: test_hash.c: split test_hash_init

Split up test_hash_init so that it calls each test more explicitly insofar
it is possible without rewriting the entire file.  This aims at improving
readability.

Split tests performed on string_or as they don't interfere with those
performed in hash_or.  Also separate pr_info calls about skipped tests as
they're not part of the tests themselves, but only warn about (un)defined
arch-specific hash functions.

Link: https://lkml.kernel.org/r/20211208183711.390454-4-isabbasso@riseup.net
Reviewed-by: David Gow <davidgow@google.com>
Tested-by: David Gow <davidgow@google.com>
Signed-off-by: Isabella Basso <isabbasso@riseup.net>
Cc: Augusto Dur=C3=A3es Camargo <augusto.duraes33@gmail.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Enzo Ferreira <ferreiraenzoa@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hash.c |   66 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 54 insertions(+), 12 deletions(-)

--- a/lib/test_hash.c~test_hashc-split-test_hash_init
+++ a/lib/test_hash.c
@@ -158,11 +158,39 @@ test_int_hash(unsigned long long h64, u3
=20
 #define SIZE 256	/* Run time is cubic in SIZE */
=20
-static int __init
-test_hash_init(void)
+static int __init test_string_or(void)
 {
 	char buf[SIZE+1];
-	u32 string_or =3D 0, hash_or[2][33] =3D { { 0, } };
+	u32 string_or =3D 0;
+	int i, j;
+
+	fill_buf(buf, SIZE, 1);
+
+	/* Test every possible non-empty substring in the buffer. */
+	for (j =3D SIZE; j > 0; --j) {
+		buf[j] =3D '\0';
+
+		for (i =3D 0; i <=3D j; i++) {
+			u32 h0 =3D full_name_hash(buf+i, buf+i, j-i);
+
+			string_or |=3D h0;
+		} /* i */
+	} /* j */
+
+	/* The OR of all the hash values should cover all the bits */
+	if (~string_or) {
+		pr_err("OR of all string hash results =3D %#x !=3D %#x",
+		       string_or, -1u);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __init test_hash_or(void)
+{
+	char buf[SIZE+1];
+	u32 hash_or[2][33] =3D { { 0, } };
 	unsigned tests =3D 0;
 	unsigned long long h64 =3D 0;
 	int i, j;
@@ -192,7 +220,6 @@ test_hash_init(void)
 				return -EINVAL;
 			}
=20
-			string_or |=3D h0;
 			h64 =3D h64 << 32 | h0;	/* For use with hash_64 */
 			if (!test_int_hash(h64, hash_or))
 				return -EINVAL;
@@ -200,12 +227,6 @@ test_hash_init(void)
 		} /* i */
 	} /* j */
=20
-	/* The OR of all the hash values should cover all the bits */
-	if (~string_or) {
-		pr_err("OR of all string hash results =3D %#x !=3D %#x",
-			string_or, -1u);
-		return -EINVAL;
-	}
 	if (~hash_or[0][0]) {
 		pr_err("OR of all __hash_32 results =3D %#x !=3D %#x",
 			hash_or[0][0], -1u);
@@ -237,6 +258,13 @@ test_hash_init(void)
 		}
 	}
=20
+	pr_notice("%u tests passed.", tests);
+
+	return 0;
+}
+
+static void __init notice_skipped_tests(void)
+{
 	/* Issue notices about skipped tests. */
 #ifdef HAVE_ARCH__HASH_32
 #if HAVE_ARCH__HASH_32 !=3D 1
@@ -252,10 +280,24 @@ test_hash_init(void)
 #else
 	pr_info("hash_64() has no arch implementation to test.");
 #endif
+}
=20
-	pr_notice("%u tests passed.", tests);
+static int __init
+test_hash_init(void)
+{
+	int ret;
=20
-	return 0;
+	ret =3D test_string_or();
+	if (ret < 0)
+		return ret;
+
+	ret =3D test_hash_or();
+	if (ret < 0)
+		return ret;
+
+	notice_skipped_tests();
+
+	return ret;
 }
=20
 static void __exit test_hash_exit(void)
_

Patches currently in -mm which might be from isabbasso@riseup.net are


