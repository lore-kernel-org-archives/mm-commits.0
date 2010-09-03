From: akpm@linux-foundation.org
Subject: + hpet-unmap-unused-i-o-space.patch added to -mm tree
Date: Fri, 03 Sep 2010 13:19:49 -0700
Message-ID: <201009032019.o83KJnVa010265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756715Ab0ICUUB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 16:20:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, clemens@ladisch.de, olaf@aepfle.de, stable@kernel.org


The patch titled
     hpet: unmap unused I/O space
has been added to the -mm tree.  Its filename is
     hpet-unmap-unused-i-o-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpet: unmap unused I/O space
From: Jiri Slaby <jslaby@suse.cz>

When the initialization code in hpet finds a memory resource and does not
find an IRQ, it does not unmap the memory resource previously mapped.

There are buggy BIOSes which report resources exactly like this and what
is worse the memory region bases point to normal RAM.  This normally would
not matter since the space is not touched.  But when PAT is turned on,
ioremap causes the page to be uncached and sets this bit in page->flags.

Then when the page is about to be used by the allocator, it is reported
as:

BUG: Bad page state in process md5sum  pfn:3ed00
page:ffffea0000dbd800 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x20000001000000(uncached)
Pid: 7956, comm: md5sum Not tainted 2.6.34-12-desktop #1
Call Trace:
 [<ffffffff810df851>] bad_page+0xb1/0x100
 [<ffffffff810dfa45>] prep_new_page+0x1a5/0x1c0
 [<ffffffff810dfe01>] get_page_from_freelist+0x3a1/0x640
 [<ffffffff810e01af>] __alloc_pages_nodemask+0x10f/0x6b0
...

In this particular case:

1) HPET returns 3ed00000 as memory region base, but it is not in
reserved ranges reported by the BIOS (excerpt):
 BIOS-e820: 0000000000100000 - 00000000af6cf000 (usable)
 BIOS-e820: 00000000af6cf000 - 00000000afdcf000 (reserved)

2) there is no IRQ resource reported by HPET method. On the other
hand, the Intel HPET specs (1.0a) says (3.2.5.1):
_CRS (
  // Report 1K of memory consumed by this Timer Block
  memory range consumed
  // Optional: only used if BIOS allocates Interrupts [1]
  IRQs consumed
)

[1] For case where Timer Block is configured to consume IRQ0/IRQ8 AND
Legacy 8254/Legacy RTC hardware still exists, the device objects
associated with 8254 & RTC devices should not report IRQ0/IRQ8 as
"consumed resources".

So in theory we should check whether if it is the case and use those
interrupts instead.

Anyway the address reported by the BIOS here is bogus, so non-presence
of IRQ doesn't mean the "optional" part in point 2).

Since I got no reply previously, fix this by simply unmapping the space
when IRQ is not found and memory region was mapped previously.  It would
be probably more safe to walk the resources again and unmap appropriately
depending on type.  But as we now use only ioremap for both 2 memory
resource types, it is not necessarily needed right now.

Addresses https://bugzilla.novell.com/show_bug.cgi?id=629908

Reported-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/char/hpet.c~hpet-unmap-unused-i-o-space drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-unmap-unused-i-o-space
+++ a/drivers/char/hpet.c
@@ -970,6 +970,8 @@ static int hpet_acpi_add(struct acpi_dev
 		return -ENODEV;
 
 	if (!data.hd_address || !data.hd_nirqs) {
+		if (data.hd_address)
+			iounmap(data.hd_address);
 		printk("%s: no address or irqs in _CRS\n", __func__);
 		return -ENODEV;
 	}
_

Patches currently in -mm which might be from jslaby@suse.cz are

maintainers-remove-drivers-char-hpetc.patch
linux-next.patch
hpet-unmap-unused-i-o-space.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch

