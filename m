Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE58C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiATCJS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:09:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50934 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358186AbiATCJP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1B54B81C9B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EDCC004E1;
        Thu, 20 Jan 2022 02:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644553;
        bh=/C5G73PKeQcSOBBcU1X+kkrp9RH/HiRBejYiec50hi4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=He7yJZ2SfJ8GWqgeqrvBrI3rHZeKuUket5lyoS6Gl9e7XRMXyTuXj5SOegcdJM52e
         knz5LWyUx+5T46u5OBT45QHDW5+VPuNnNLC9byv6LyjcEd2LJf2APRxEEiFbiVud6q
         PQI07uC9f+kLYLHqAxposJqZk3WMOMYX+gmwMjpc=
Date:   Wed, 19 Jan 2022 18:09:12 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, augusto.duraes33@gmail.com,
        brendanhiggins@google.com, davidgow@google.com,
        dlatypov@google.com, ferreiraenzoa@gmail.com, geert@linux-m68k.org,
        isabbasso@riseup.net, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, rodrigosiqueiramelo@gmail.com,
        skhan@linuxfoundation.org, torvalds@linux-foundation.org
Subject:  [patch 28/55] lib/Kconfig.debug: properly split hash test
 kernel entries
Message-ID: <20220120020912.-NS2X1Va2%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Isabella Basso <isabbasso@riseup.net>
Subject: lib/Kconfig.debug: properly split hash test kernel entries

Split TEST_HASH so that each entry only has one file.

Note that there's no stringhash test file, but actually
<linux/stringhash.h> tests are performed in lib/test_hash.c.

Link: https://lkml.kernel.org/r/20211208183711.390454-5-isabbasso@riseup.net
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

 lib/Kconfig.debug |   14 +++++++++++---
 lib/Makefile      |    3 ++-
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-properly-split-hash-test-kernel-en=
tries
+++ a/lib/Kconfig.debug
@@ -2210,9 +2210,17 @@ config TEST_RHASHTABLE
 config TEST_HASH
 	tristate "Perform selftest on hash functions"
 	help
-	  Enable this option to test the kernel's integer (<linux/hash.h>),
-	  string (<linux/stringhash.h>), and siphash (<linux/siphash.h>)
-	  hash functions on boot (or module load).
+	  Enable this option to test the kernel's integer (<linux/hash.h>), and
+	  string (<linux/stringhash.h>) hash functions on boot (or module load).
+
+	  This is intended to help people writing architecture-specific
+	  optimized versions.  If unsure, say N.
+
+config TEST_SIPHASH
+	tristate "Perform selftest on siphash functions"
+	help
+	  Enable this option to test the kernel's siphash (<linux/siphash.h>) hash
+	  functions on boot (or module load).
=20
 	  This is intended to help people writing architecture-specific
 	  optimized versions.  If unsure, say N.
--- a/lib/Makefile~lib-kconfigdebug-properly-split-hash-test-kernel-entries
+++ a/lib/Makefile
@@ -61,7 +61,8 @@ obj-$(CONFIG_TEST_FIRMWARE) +=3D test_firm
 obj-$(CONFIG_TEST_BITOPS) +=3D test_bitops.o
 CFLAGS_test_bitops.o +=3D -Werror
 obj-$(CONFIG_TEST_SYSCTL) +=3D test_sysctl.o
-obj-$(CONFIG_TEST_HASH) +=3D test_hash.o test_siphash.o
+obj-$(CONFIG_TEST_SIPHASH) +=3D test_siphash.o
+obj-$(CONFIG_TEST_HASH) +=3D test_hash.o
 obj-$(CONFIG_TEST_IDA) +=3D test_ida.o
 obj-$(CONFIG_KASAN_KUNIT_TEST) +=3D test_kasan.o
 CFLAGS_test_kasan.o +=3D -fno-builtin
_
