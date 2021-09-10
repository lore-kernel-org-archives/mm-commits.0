Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB49DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CDAA610C8
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhIJDLA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 23:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhIJDK7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 23:10:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 558E7600CC;
        Fri, 10 Sep 2021 03:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631243389;
        bh=k5M+dC02uZd8hljTHru4d+S3cHV/kZ2w8eoFWLMjwZA=;
        h=Date:From:To:Cc:Subject:From;
        b=Npl3RHghT6pjGFAT+JSTCAbRuw0mRwZSelVBPNGes/AWXVflqyb4xlO6kUtXGOJkT
         mwYWep7txbqoCsqXTZyhNRaxWVSNXWDWbDM13MdRbPHvgkMXgzxBg0Smx2p6e3ZtTR
         hV+jA9FJFm3cb0/VusAnJunP0pVl75AV3mU4muEk=
Date:   Thu, 9 Sep 2021 20:09:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


More post linux-next material.

9 patches, based on f154c806676ad7153c6e161f30c53a44855329d6.

Subsystems affected by this patch series:

  mm/slab-generic
  rapidio
  mm/debug

Subsystem: mm/slab-generic

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm: move kvmalloc-related functions to slab.h

Subsystem: rapidio

    Kees Cook <keescook@chromium.org>:
      rapidio: avoid bogus __alloc_size warning

Subsystem: mm/debug

    Kees Cook <keescook@chromium.org>:
    Patch series "Add __alloc_size() for better bounds checking", v2:
      Compiler Attributes: add __alloc_size() for better bounds checking
      checkpatch: add __alloc_size() to known $Attribute
      slab: clean up function declarations
      slab: add __alloc_size attributes for better bounds checking
      mm/page_alloc: add __alloc_size attributes for better bounds checking
      percpu: add __alloc_size attributes for better bounds checking
      mm/vmalloc: add __alloc_size attributes for better bounds checking

 Makefile                                 |   15 +++
 drivers/of/kexec.c                       |    1 
 drivers/rapidio/devices/rio_mport_cdev.c |    9 +-
 include/linux/compiler_attributes.h      |    6 +
 include/linux/gfp.h                      |    2 
 include/linux/mm.h                       |   34 --------
 include/linux/percpu.h                   |    3 
 include/linux/slab.h                     |  122 ++++++++++++++++++++++---------
 include/linux/vmalloc.h                  |   11 ++
 scripts/checkpatch.pl                    |    3 
 10 files changed, 132 insertions(+), 74 deletions(-)

