Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E4BDDD2
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337156; cv=none; b=CACzc9C4gz1QWtowHyrmmBjuhWODGyOzqfzRfnP/sm/wRMhSlGgIyGQjzrjUz6srZqFpnSl2kR+CR0ZqUzBwAgkGe/7B8Fku53HYAVillGY3XrkQatWWBNlun731NvzXdaPDT/cswpEiJ5bRJM/t3ekiS4bnF++8RyjKGjFyqvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337156; c=relaxed/simple;
	bh=2zyLxPlx6/ymikZU2wLqbXrNB7d2jJ1wDyGjcvM1RfQ=;
	h=Date:To:From:Subject:Message-Id; b=akIZd7PusrVAHoyDVeGtQA2ew2eKhqYs8eAsPzDHL/ZgAEkkCBTgINYyorPLWn4fKyu6Qch242Dyuz3RucOZF470NZdSkmfKVOu3mVyqKKtEGXrdfw18Voz/3+Ewp3CxlkmwBARs+1Z/gjzC5wlR0KlMDPavO59J3DlzzpeV5LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fxHiaFze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fxHiaFze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364AEC4CED6;
	Mon, 20 Jan 2025 01:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337156;
	bh=2zyLxPlx6/ymikZU2wLqbXrNB7d2jJ1wDyGjcvM1RfQ=;
	h=Date:To:From:Subject:From;
	b=fxHiaFzesbWg1BFo8OpHI9dXCBtOrq0KUQP23TxKbVLsq9fki+ZvzhZ2qRPEGTFVy
	 MF2ehL4K8l8YPCJU2W4WlkYZ0O2DCku8J7NYyDk770+iVaF2JXJNV3djLq3nRxWehC
	 8ytDZJQUTEjCyh4dO2Z9m28r55kQH3rRPHUegKMY=
Date: Sun, 19 Jan 2025 17:39:15 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shuah@kernel.org,oliver.sang@intel.com,khandual@linux.vnet.ibm.com,dev.jain@arm.com,david@redhat.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-virtual_address_range-mmap-without-prot_write.patch removed from -mm tree
Message-Id: <20250120013916.364AEC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: virtual_address_range: mmap() without PROT_WRITE
has been removed from the -mm tree.  Its filename was
     selftests-mm-virtual_address_range-mmap-without-prot_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: selftests/mm: virtual_address_range: mmap() without PROT_WRITE
Date: Tue, 14 Jan 2025 17:06:45 +0100

Patch series "selftests/mm: virtual_address_range: Reduce memory", v4.

The selftest started failing since commit e93d2521b27f ("x86/vdso: Split
virtual clock pages into dedicated mapping") was merged.  While debugging
I stumbled upon some memory usage optimizations.

With these test now runs on a VM with only 60MiB of memory.


This patch (of 4):

When mapping a larger chunk than physical memory is available with
PROT_WRITE and overcommit is disabled, the mapping will fail.  This will
prevent the test from running on systems with less then ~1GiB of memory
and triggering an inscrutinable test failure.  As the mappings are never
written to anyways, the flag can be removed.

Link: https://lkml.kernel.org/r/20250114-virtual_address_range-tests-v4-0-6fd7269934a5@linutronix.de
Link: https://lkml.kernel.org/r/20250114-virtual_address_range-tests-v4-1-6fd7269934a5@linutronix.de
Fixes: 4e5ce33ceb32 ("selftests/vm: add a test for virtual address range mapping")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-virtual_address_range-mmap-without-prot_write
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -166,7 +166,7 @@ int main(int argc, char *argv[])
 	ksft_set_plan(1);
 
 	for (i = 0; i < NR_CHUNKS_LOW; i++) {
-		ptr[i] = mmap(NULL, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
+		ptr[i] = mmap(NULL, MAP_CHUNK_SIZE, PROT_READ,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
 		if (ptr[i] == MAP_FAILED) {
@@ -186,7 +186,7 @@ int main(int argc, char *argv[])
 
 	for (i = 0; i < NR_CHUNKS_HIGH; i++) {
 		hint = hint_addr();
-		hptr[i] = mmap(hint, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
+		hptr[i] = mmap(hint, MAP_CHUNK_SIZE, PROT_READ,
 			       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
 		if (hptr[i] == MAP_FAILED)
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are


