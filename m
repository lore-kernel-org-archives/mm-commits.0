From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Sun, 12 Apr 2020 00:41:55 -0700
Message-ID: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgDLHl5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 12 Apr 2020 03:41:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org


A straggler.  This patch caused a lot of build errors on a lot of
architectures for a long time, but Anshuman believes it's all fixed up
now.

1 patch, based on GIT b032227c62939b5481bcd45442b36dfa263f4a7c.

    Anshuman Khandual <anshuman.khandual@arm.com>:
      mm/debug: add tests validating architecture page table helpers

 Documentation/features/debug/debug-vm-pgtable/arch-support.txt |   34 
 arch/arc/Kconfig                                               |    1 
 arch/arm64/Kconfig                                             |    1 
 arch/powerpc/Kconfig                                           |    1 
 arch/s390/Kconfig                                              |    1 
 arch/x86/Kconfig                                               |    1 
 arch/x86/include/asm/pgtable_64.h                              |    6 
 include/linux/mmdebug.h                                        |    5 
 init/main.c                                                    |    2 
 lib/Kconfig.debug                                              |   26 
 mm/Makefile                                                    |    1 
 mm/debug_vm_pgtable.c                                          |  392 ++++++++++
 12 files changed, 471 insertions(+)
