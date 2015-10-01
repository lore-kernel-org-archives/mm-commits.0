From: akpm@linux-foundation.org
Subject: + mm-optimize-pagehighmem-check.patch added to -mm tree
Date: Thu, 01 Oct 2015 16:25:35 -0700
Message-ID: <560dc0ef.j5TxCaW3In2ADg4L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbJAXZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 19:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, hughd@google.com, jennifer.herbert@citrix.com, khlebnikov@yandex-team.ru, kirill.shutemov@linux.intel.com, mhocko@suse.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: optimize PageHighMem() check
has been added to the -mm tree.  Its filename is
     mm-optimize-pagehighmem-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-optimize-pagehighmem-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-optimize-pagehighmem-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: mm: optimize PageHighMem() check

This came up when implementing HIHGMEM/PAE40 for ARC.  The kmap() /
kmap_atomic() generated code seemed needlessly bloated due to the way
PageHighMem() macro is implemented.  It derives the exact zone for page
and then does pointer subtraction with first zone to infer the zone_type. 
The pointer arithmatic in turn generates the code bloat.

PageHighMem(page)
  is_highmem(page_zone(page))
     zone_off = (char *)zone - (char *)zone->zone_pgdat->node_zones

Instead use is_highmem_idx() to work on zone_type available in page flags

   ----- Before -----
80756348:	mov_s      r13,r0
8075634a:	ld_s       r2,[r13,0]
8075634c:	lsr_s      r2,r2,30
8075634e:	mpy        r2,r2,0x2a4
80756352:	add_s      r2,r2,0x80aef880
80756358:	ld_s       r3,[r2,28]
8075635a:	sub_s      r2,r2,r3
8075635c:	breq       r2,0x2a4,80756378 <kmap+0x48>
80756364:	breq       r2,0x548,80756378 <kmap+0x48>

   ----- After  -----
80756330:	mov_s      r13,r0
80756332:	ld_s       r2,[r13,0]
80756334:	lsr_s      r2,r2,30
80756336:	sub_s      r2,r2,1
80756338:	brlo       r2,2,80756348 <kmap+0x30>

For x86 defconfig build (32 bit only) it saves around 900 bytes.
For ARC defconfig with HIGHMEM, it saved around 2K bytes.

   ---->8-------
./scripts/bloat-o-meter x86/vmlinux-defconfig-pre x86/vmlinux-defconfig-post
add/remove: 0/0 grow/shrink: 0/36 up/down: 0/-934 (-934)
function                                     old     new   delta
saveable_page                                162     154      -8
saveable_highmem_page                        154     146      -8
skb_gro_reset_offset                         147     131     -16
...
...
__change_page_attr_set_clr                  1715    1678     -37
setup_data_read                              434     394     -40
mon_bin_event                               1967    1927     -40
swsusp_save                                 1148    1105     -43
_set_pages_array                             549     493     -56
   ---->8-------

e.g. For ARC kmap()

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jennifer Herbert <jennifer.herbert@citrix.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~mm-optimize-pagehighmem-check include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-optimize-pagehighmem-check
+++ a/include/linux/page-flags.h
@@ -256,7 +256,7 @@ PAGEFLAG(Readahead, reclaim) TESTCLEARFL
  * Must use a macro here due to header dependency issues. page_zone() is not
  * available at this point.
  */
-#define PageHighMem(__p) is_highmem(page_zone(__p))
+#define PageHighMem(__p) is_highmem_idx(page_zonenum(__p))
 #else
 PAGEFLAG_FALSE(HighMem)
 #endif
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are

mm-optimize-pagehighmem-check.patch

