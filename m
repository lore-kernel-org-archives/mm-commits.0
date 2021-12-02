Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853F3C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 04:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbhLBEuV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 23:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbhLBEuT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 23:50:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF4DC061574
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 20:46:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52D97CE2152
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 04:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B786C00446;
        Thu,  2 Dec 2021 04:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638420413;
        bh=/gJ06pbUngskJY7AE9EJedm6nE5e1H5jH55HhZSL6Ug=;
        h=Date:From:To:Subject:From;
        b=0Y2/tMPEs1LLr6JtS/9lNJr5EVOBAlPLr/RiqncaUfMdM0gUlE6ss+uPCKxO1iAZc
         HTCgPtYw+lhp8bHOyb6Wy9ozuoomq23jZ0noeVmStNaAQnABpdDPEYMMH0NImsEi6G
         2WiGA00ILEdYRiXNgm7AzDtpGfRhjbYKOIOAPmKY=
Date:   Wed, 01 Dec 2021 20:46:52 -0800
From:   akpm@linux-foundation.org
To:     clm@fb.com, dsterba@suse.com, josef@toxicpanda.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Subject:  +
 =?US-ASCII?Q?arch-kconfig-split-page=5Fsize=5Fless=5Fthan=5F256kb-from-pa?=
 =?US-ASCII?Q?ge=5Fsize=5Fless=5Fthan=5F64kb.patch?= added to -mm tree
Message-ID: <20211202044652.hZzgBbkVF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/Kconfig: split PAGE_SIZE_LESS_THAN_256KB from PAGE_SIZE_LESS_THAN_64KB
has been added to the -mm tree.  Its filename is
     arch-kconfig-split-page_size_less_than_256kb-from-page_size_less_than_64kb.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-kconfig-split-page_size_less_than_256kb-from-page_size_less_than_64kb.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-kconfig-split-page_size_less_than_256kb-from-page_size_less_than_64kb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: arch/Kconfig: split PAGE_SIZE_LESS_THAN_256KB from PAGE_SIZE_LESS_THAN_64KB

Patch series "Fix CONFIG_TEST_KMOD with 256kB page size".

The kernel test robot reported a build error [1] from a failed assertion
in fs/btrfs/inode.c with a hexagon randconfig that includes
CONFIG_PAGE_SIZE_256KB.  This error is the same one that was addressed by
commit b05fbcc36be1 ("btrfs: disable build on platforms having page size
256K") but CONFIG_TEST_KMOD selects CONFIG_BTRFS without having the "page
size less than 256kB dependency", which results in the error reappearing.

The first patch introduces CONFIG_PAGE_SIZE_LESS_THAN_256KB by splitting
it off from CONFIG_PAGE_SIZE_LESS_THAN_64KB, which was introduced in
commit 1f0e290cc5fd ("arch: Add generic Kconfig option indicating page
size smaller than 64k") for a similar reason in 5.16-rc3.

The second patch uses that configuration option for CONFIG_BTRFS to reduce
duplication.

The third patch resolves the build error by adding
CONFIG_PAGE_SIZE_LESS_THAN_256KB as a dependency to CONFIG_TEST_KMOD so
that CONFIG_BTRFS does not get enabled under that invalid configuration.

[1]: https://lore.kernel.org/r/202111270255.UYOoN5VN-lkp@intel.com/


This patch (of 3):

btrfs requires a page size smaller than 256kB.  To use that dependency in
other places, introduce CONFIG_PAGE_SIZE_LESS_THAN_256KB and reuse that
dependency in CONFIG_PAGE_SIZE_LESS_THAN_64KB.

Link: https://lkml.kernel.org/r/20211129230141.228085-1-nathan@kernel.org
Link: https://lkml.kernel.org/r/20211129230141.228085-2-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/Kconfig~arch-kconfig-split-page_size_less_than_256kb-from-page_size_less_than_64kb
+++ a/arch/Kconfig
@@ -1005,6 +1005,10 @@ config PAGE_SIZE_LESS_THAN_64KB
 	depends on !PAGE_SIZE_64KB
 	depends on !PARISC_PAGE_SIZE_64KB
 	depends on !PPC_64K_PAGES
+	depends on PAGE_SIZE_LESS_THAN_256KB
+
+config PAGE_SIZE_LESS_THAN_256KB
+	def_bool y
 	depends on !PPC_256K_PAGES
 	depends on !PAGE_SIZE_256KB
 
_

Patches currently in -mm which might be from nathan@kernel.org are

arch-kconfig-split-page_size_less_than_256kb-from-page_size_less_than_64kb.patch
btrfs-use-generic-kconfig-option-for-256kb-page-size-limit.patch
lib-kconfigdebug-make-test_kmod-depend-on-page_size_less_than_256kb.patch

