Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7F8C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07B5D2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196056;
	bh=LmVqpVT/o2yQDQw0oRVmn9+6TGonpse65Z+TUo/k4Y4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=wZ78c5Rzgs+0nyQUm5yTvnOa4J4mDPdRty6UwcDF5EcLXHctsHmmBlOzJnMxc3MNB
	 tW1wcORf4x1BMKi1VgVSozDD/Fj3GdMm0VpnftFbr8eIcPtPCha1YZKiR9fHCt88LE
	 8SqHYsLspGqMNmhU1iEy7uxZd7+batBW9bLPNOpo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLBeP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgHLBeP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24BD9208A9;
        Wed, 12 Aug 2020 01:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196054;
        bh=LmVqpVT/o2yQDQw0oRVmn9+6TGonpse65Z+TUo/k4Y4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WqCnx6DmTPoQqbMUopqWZfIi1+Q+5266Wchkek9fxA1BCBsi2WDKigyUaIwul7xRo
         Safvmkkolvp+E/WkW8ZWFRO7QVeAjSnBrFY4Kxzu5+yMVtCYDoCMphhG9gq2jLND/I
         nfK1exvxBLAUi3nQXfZ7iHez0D+LzUJIqjPBmyOk=
Date:   Tue, 11 Aug 2020 18:34:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andi.kleen@intel.com,
        andriy.shevchenko@intel.com, feng.tang@intel.com,
        linux-mm@kvack.org, masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        ying.huang@intel.com
Subject:  [patch 075/165] ./Makefile: add debug option to enable
 function aligned on 32 bytes
Message-ID: <20200812013413.iMkfGJxco%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>
Subject: ./Makefile: add debug option to enable function aligned on 32 bytes

Recently 0day reported many strange performance changes (regression or
improvement), in which there was no obvious relation between the culprit
commit and the benchmark at the first look, and it causes people to doubt
the test itself is wrong.

Upon further check, many of these cases are caused by the change to the
alignment of kernel text or data, as whole text/data of kernel are linked
together, change in one domain may affect alignments of other domains.

gcc has an option '-falign-functions=n' to force text aligned, and with
that option enabled, some of those performance changes will be gone, like
[1][2][3].

Add this option so that developers and 0day can easily find performance
bump caused by text alignment change, as tracking these strange bump is
quite time consuming.  Though it can't help in other cases like data
alignment changes like [4].

Following is some size data for v5.7 kernel built with a RHEL config used
in 0day:

    text      data      bss	 dec	   filename
  19738771  13292906  5554236  38585913	 vmlinux.noalign
  19758591  13297002  5529660  38585253	 vmlinux.align32

Raw vmlinux size in bytes:

	v5.7		v5.7+align32
	253950832	254018000	+0.02%

Some benchmark data, most of them have no big change:

  * hackbench:		[ -1.8%,  +0.5%]

  * fsmark:		[ -3.2%,  +3.4%]  # ext4/xfs/btrfs

  * kbuild:		[ -2.0%,  +0.9%]

  * will-it-scale:	[ -0.5%,  +1.8%]  # mmap1/pagefault3

  * netperf:
    - TCP_CRR		[+16.6%, +97.4%]
    - TCP_RR		[-18.5%,  -1.8%]
    - TCP_STREAM	[ -1.1%,  +1.9%]

[1] https://lore.kernel.org/lkml/20200114085637.GA29297@shao2-debian/
[2] https://lore.kernel.org/lkml/20200330011254.GA14393@feng-iot/
[3] https://lore.kernel.org/lkml/1d98d1f0-fe84-6df7-f5bd-f4cb2cdb7f45@intel.com/
[4] https://lore.kernel.org/lkml/20200205123216.GO12867@shao2-debian/

Link: http://lkml.kernel.org/r/1595475001-90945-1-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile          |    4 ++++
 lib/Kconfig.debug |   11 +++++++++++
 2 files changed, 15 insertions(+)

--- a/lib/Kconfig.debug~makefile-add-debug-option-to-enable-function-aligned-on-32-bytes
+++ a/lib/Kconfig.debug
@@ -365,6 +365,17 @@ config SECTION_MISMATCH_WARN_ONLY
 
 	  If unsure, say Y.
 
+config DEBUG_FORCE_FUNCTION_ALIGN_32B
+	bool "Force all function address 32B aligned" if EXPERT
+	help
+	  There are cases that a commit from one domain changes the function
+	  address alignment of other domains, and cause magic performance
+	  bump (regression or improvement). Enable this option will help to
+	  verify if the bump is caused by function alignment changes, while
+	  it will slightly increase the kernel size and affect icache usage.
+
+	  It is mainly for debug and performance tuning use.
+
 #
 # Select this config option from the architecture Kconfig, if it
 # is preferred to always offer frame pointers as a config
--- a/Makefile~makefile-add-debug-option-to-enable-function-aligned-on-32-bytes
+++ a/Makefile
@@ -893,6 +893,10 @@ KBUILD_CFLAGS	+= $(CC_FLAGS_SCS)
 export CC_FLAGS_SCS
 endif
 
+ifdef CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_32B
+KBUILD_CFLAGS += -falign-functions=32
+endif
+
 # arch Makefile may override CC so keep this after arch Makefile is included
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 
_
