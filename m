Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 446CFC433E0
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 037B664E3D
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbhBMEw4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 23:52:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhBMEwr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 23:52:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD8FD64DEC;
        Sat, 13 Feb 2021 04:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613191927;
        bh=p2UdrpsMERt+zDj5yCnSUFyYTJcFxS2Y723yLp2otRE=;
        h=Date:From:To:Cc:Subject:From;
        b=XWnQxwpCp9YG8BVttbiklX4GrmMBsChxzN6T8OH8KcBe2XNdNUA37Y8/ckN69jslW
         VKki5M1Xb5bJyemTBwSWbbqzhIM+M8aXT85WzdT914DBvAaMAHxpbI01kwD5kz1x+g
         rjAtArN03jKkY0vc9CQK0cCB1MQrxgLg+9YCgNU8=
Date:   Fri, 12 Feb 2021 20:52:06 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210212205206.f99cbe2e7e368c802a385104@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

6 patches, based on dcc0b49040c70ad827a7f3d58a21b01fdb14e749.

Subsystems affected by this patch series:

  mm/pagemap
  scripts
  MAINTAINERS
  h8300

Subsystem: mm/pagemap

    Mike Rapoport <rppt@linux.ibm.com>:
      m68k: make __pfn_to_phys() and __phys_to_pfn() available for !MMU

Subsystem: scripts

    Rong Chen <rong.a.chen@intel.com>:
      scripts/recordmcount.pl: support big endian for ARCH sh

Subsystem: MAINTAINERS

    Andrey Konovalov <andreyknvl@google.com>:
      MAINTAINERS: update KASAN file list
      MAINTAINERS: update Andrey Konovalov's email address
      MAINTAINERS: add Andrey Konovalov to KASAN reviewers

Subsystem: h8300

    Randy Dunlap <rdunlap@infradead.org>:
      h8300: fix PREEMPTION build, TI_PRE_COUNT undefined

 MAINTAINERS                     |    8 +++++---
 arch/h8300/kernel/asm-offsets.c |    3 +++
 arch/m68k/include/asm/page.h    |    2 +-
 scripts/recordmcount.pl         |    6 +++++-
 4 files changed, 14 insertions(+), 5 deletions(-)

