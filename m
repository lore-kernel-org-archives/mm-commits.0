Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAE7C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 23:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241148AbhLHXa2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Dec 2021 18:30:28 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34188 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbhLHXa2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2021 18:30:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 46816CE241B
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 23:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D45AC341C7;
        Wed,  8 Dec 2021 23:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639006012;
        bh=0J8K2Z1FyOtiFqnxiFyn9x8rcU563DcflcxKSxgFgCI=;
        h=Date:From:To:Subject:From;
        b=Es6bKe6ntTTXJTHpg7/eQav1BGP9yza6nWjxvbmeQg+8EArJuRlAzie60jD5AAF5z
         +XHw1qRNfMaPkpI+kKm03mu0eQH3ia/gg5l4tHq+BkUyFvgjXtGwv6WL3keQgXxD4T
         TFWA2Mb3xZN/rBRLQIhoPbG8ex/xHtfJPm1rWWIw=
Date:   Wed, 08 Dec 2021 15:26:51 -0800
From:   akpm@linux-foundation.org
To:     augusto.duraes33@gmail.com, brendanhiggins@google.com,
        davidgow@google.com, dlatypov@google.com, ferreiraenzoa@gmail.com,
        geert@linux-m68k.org, isabbasso@riseup.net, lkp@intel.com,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        rodrigosiqueiramelo@gmail.com, skhan@linuxfoundation.org
Subject:  +
 lib-kconfigdebug-properly-split-hash-test-kernel-entries.patch added to -mm
 tree
Message-ID: <20211208232651.zvqrLZEHQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: properly split hash test kernel entries
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-properly-split-hash-test-kernel-entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-kconfigdebug-properly-spl=
it-hash-test-kernel-entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfigdebug-properly-spl=
it-hash-test-kernel-entries.patch

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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
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
@@ -2215,9 +2215,17 @@ config TEST_RHASHTABLE
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

Patches currently in -mm which might be from isabbasso@riseup.net are

hashh-remove-unused-define-directive.patch
test_hashc-split-test_int_hash-into-arch-specific-functions.patch
test_hashc-split-test_hash_init.patch
lib-kconfigdebug-properly-split-hash-test-kernel-entries.patch
test_hashc-refactor-into-kunit.patch

