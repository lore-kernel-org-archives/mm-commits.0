From: akpm@linux-foundation.org
Subject: + linux-hpet-issue-with-amd-southbridges.patch added to -mm tree
Date: Wed, 27 Jun 2007 12:23:57 -0700
Message-ID: <200706271923.l5RJNwWH003966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57539 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbXF0TYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 15:24:33 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l5RJO3cP003007
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 27 Jun 2007 12:24:04 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: torvalds@linux-foundation.org


The patch titled
     Linux HPET issue with AMD southbridges
has been added to the -mm tree.  Its filename is
     linux-hpet-issue-with-amd-southbridges.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux HPET issue with AMD southbridges
From: Linus Torvalds <torvalds@linux-foundation.org>

On Wed, 27 Jun 2007, Matthias Lenk wrote:
>
> I attached the output of cat /proc/iomem when booting with hpet=disable. As
> you can see the HPET address is still 0xfed00000 where it is supposed to be
> while the new hardware base address for the HPET is 0x30000000 which is
> allocated for device 0:14.0 (SMBus controller). For all ATI southbridges the
> HPET base is at BAR1 of device 0:14.0.

Ok. The problem is, as I suspected, too early firmware resource
allocation. In this case, it's "acpi_parse_hpet()" that reserves the
resource too early.

The bug was apparently introduced by commit f0f4c3432e5e: "i386: add
HPET(s) into resource map" by Aaron Durbin.

So the rule for these kinds of things really *must* be:

 - read the firmware info early if you want to.

 - but firmware *must*not* mark IO regions as being reserved until after
   the PCI resource parsing has been done. In particular, they must not be
   marked busy.

I _think_ that the fix in this case may actually be as trivial as just
removing the BUSY on the resource. In that case, the PCI layer will be
able to insert the resource it knows about, and everything is fine. It
just won't be allocating *new* resources over it (which is obviously what
we want).

So I *think* that this patch may "Just Work(tm)". But it's obviously
totally untested, since I don't have the hardware that can trigger this.
I'd really appreciate testing. And I won't guarantee it does, but I'd love
to see the whole "dmesg" output regardless..

I don't think it's the *best* patch. I think a better patch would
literally be to do the whole firmware resource adding at a later stage,
after we've done the PCI probing (but before we do any new allocation, of
course!).

As an example of what I think is marking resources *properly* you can see,
acpi_reserve_resources() is a "device_initcall()", so it runs long after
the PCI probing has happened, but I think it's set up so that ACPI gets
linked before any normal drivers, so it should trigger before we actually
enable the devices (and allocate missing resources for them).



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/boot.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/acpi/boot.c~linux-hpet-issue-with-amd-southbridges arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~linux-hpet-issue-with-amd-southbridges
+++ a/arch/i386/kernel/acpi/boot.c
@@ -642,7 +642,7 @@ static int __init acpi_parse_hpet(struct
 	if (hpet_res) {
 		memset(hpet_res, 0, sizeof(*hpet_res));
 		hpet_res->name = (void *)&hpet_res[1];
-		hpet_res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		hpet_res->flags = IORESOURCE_MEM;
 		snprintf((char *)hpet_res->name, HPET_RESOURCE_NAME_SIZE,
 			 "HPET %u", hpet_tbl->sequence);
 		hpet_res->end = (1 * 1024) - 1;
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

origin.patch
linux-hpet-issue-with-amd-southbridges.patch
x86_64-pm_trace-support.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
mmconfig-validate-against-acpi-motherboard-resources-fix.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-3.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2-3.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by.patch
workaround-for-a-pci-restoring-bug.patch
