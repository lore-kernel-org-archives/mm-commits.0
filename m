From: akpm@linux-foundation.org
Subject: + swapfile-fix-memory-corruption-via-malformed-swapfile.patch
 added to -mm tree
Date: Fri, 04 Nov 2016 12:29:49 -0700
Message-ID: <581ce1ad.Q85AxuUYwS3yA+uE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52142 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbcKDT3v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2016 15:29:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jann@thejh.net, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: swapfile: fix memory corruption via malformed swapfile
has been added to the -mm tree.  Its filename is
     swapfile-fix-memory-corruption-via-malformed-swapfile.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swapfile-fix-memory-corruption-via-malformed-swapfile.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swapfile-fix-memory-corruption-via-malformed-swapfile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jann@thejh.net>
Subject: swapfile: fix memory corruption via malformed swapfile

When root activates a swap partition whose header has the wrong endianness,
nr_badpages elements of badpages are swabbed before nr_badpages has been
checked, leading to a buffer overrun of up to 8GB.

This normally is not a security issue because it can only be exploited by
root (more specifically, a process with CAP_SYS_ADMIN or the ability to
modify a swap file/partition), and such a process can already e.g. modify
swapped-out memory of any other userspace process on the system.

Testcase for reproducing the bug (must be run as root, should crash your
kernel):
=================
#include <stdlib.h>
#include <unistd.h>
#include <sys/swap.h>
#include <limits.h>
#include <err.h>
#include <string.h>
#include <stdio.h>

#define PAGE_SIZE 4096
#define __u32 unsigned int

// from include/linux/swap.h
union swap_header {
  struct {
    char reserved[PAGE_SIZE - 10];
    char magic[10];     /* SWAP-SPACE or SWAPSPACE2 */
  } magic;
  struct {
    char    bootbits[1024]; /* Space for disklabel etc. */
    __u32   version;
    __u32   last_page;
    __u32   nr_badpages;
    unsigned char sws_uuid[16];
    unsigned char sws_volume[16];
    __u32   padding[117];
    __u32   badpages[1];
  } info;
};

int main(void) {
  char file[] = "/tmp/swapfile.XXXXXX";
  int file_fd = mkstemp(file);
  if (file_fd == -1)
    err(1, "mkstemp");
  if (ftruncate(file_fd, PAGE_SIZE))
    err(1, "ftruncate");
  union swap_header swap_header = {
    .info = {
      .version = __builtin_bswap32(1),
      .nr_badpages = __builtin_bswap32(INT_MAX)
    }
  };
  memcpy(swap_header.magic.magic, "SWAPSPACE2", 10);
  if (write(file_fd, &swap_header, sizeof(swap_header)) !=
      sizeof(swap_header))
    err(1, "write");

  // not because the attack needs it, just in case you forgot to
  // sync yourself before crashing your machine
  sync();

  // now die
  if (swapon(file, 0))
    err(1, "swapon");
  puts("huh, we survived");
  if (swapoff(file))
    err(1, "swapoff");
  unlink(file);
}
=================

Link: http://lkml.kernel.org/r/1477949533-2509-1-git-send-email-jann@thejh.net
Signed-off-by: Jann Horn <jann@thejh.net>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/swapfile.c~swapfile-fix-memory-corruption-via-malformed-swapfile mm/swapfile.c
--- a/mm/swapfile.c~swapfile-fix-memory-corruption-via-malformed-swapfile
+++ a/mm/swapfile.c
@@ -2224,6 +2224,8 @@ static unsigned long read_swap_header(st
 		swab32s(&swap_header->info.version);
 		swab32s(&swap_header->info.last_page);
 		swab32s(&swap_header->info.nr_badpages);
+		if (swap_header->info.nr_badpages > MAX_SWAP_BADPAGES)
+			return 0;
 		for (i = 0; i < swap_header->info.nr_badpages; i++)
 			swab32s(&swap_header->info.badpages[i]);
 	}
_

Patches currently in -mm which might be from jann@thejh.net are

swapfile-fix-memory-corruption-via-malformed-swapfile.patch

