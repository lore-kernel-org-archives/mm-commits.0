From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 11 Jun 2020 17:30:02 -0700
Message-ID: <20200611173002.24352ae77ca6d6d7e65e4b2a@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgFLAaE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 20:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org


A few fixes and stragglers.


5 patches, based on 623f6dc593eaf98b91916836785278eddddaacf8.

Subsystems affected by this patch series:

  mm/memory-failure
  ocfs2
  lib/lzo
  misc

Subsystem: mm/memory-failure

    Naoya Horiguchi <nao.horiguchi@gmail.com>:
    Patch series "hwpoison: fixes signaling on memory error":
      mm/memory-failure: prioritize prctl(PR_MCE_KILL) over vm.memory_failure_early_kill
      mm/memory-failure: send SIGBUS(BUS_MCEERR_AR) only to current thread

Subsystem: ocfs2

    Tom Seewald <tseewald@gmail.com>:
      ocfs2: fix build failure when TCP/IP is disabled

Subsystem: lib/lzo

    Dave Rodgman <dave.rodgman@arm.com>:
      lib/lzo: fix ambiguous encoding bug in lzo-rle

Subsystem: misc

    Christoph Hellwig <hch@lst.de>:
      amdgpu: a NULL ->mm does not mean a thread is a kthread

 Documentation/lzo.txt                      |    8 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |    2 -
 fs/ocfs2/Kconfig                           |    2 -
 lib/lzo/lzo1x_compress.c                   |   13 ++++++++
 mm/memory-failure.c                        |   43 +++++++++++++++++------------
 5 files changed, 47 insertions(+), 21 deletions(-)
