Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C9E2E040E;
	Tue, 28 Oct 2025 21:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761688420; cv=none; b=cSLxUOj485FAMuPXdoHmd5HJURWXv5gF6nE4trWXIs/GJ124YRpSnHxSeZQZU+D99PCDt+ftFLmcx32aJu+yrR2aLSzVfOexkG3ORnzyhVz++hl3ADm4K53XM+mgLdF8e7iesQelN1h+D/xE+HEJ0eHBr1QOnkA1MDGkXWamdDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761688420; c=relaxed/simple;
	bh=NxCqAKzuebn/CbY/tBwGbi4jDm2bHZzxnG10F91Lk0A=;
	h=Date:To:From:Subject:Message-Id; b=vEUglfO1/2K89hTPchOI5AZGMsd+EgJXtzLnTrlV4+GpsiNc4TRjozNPJcbALjsAVgHAVpST/tYdc9Il0XN7thVfvD/aK0TQ7iaVRXXgm6vIO+gXqTHjZaMjdiqRerj7hlxPXgFGGPuCzPrfjsXELXpsiy6FBWcPpMeeJSXIWAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NHVVUfe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NHVVUfe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0712C4CEE7;
	Tue, 28 Oct 2025 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761688419;
	bh=NxCqAKzuebn/CbY/tBwGbi4jDm2bHZzxnG10F91Lk0A=;
	h=Date:To:From:Subject:From;
	b=NHVVUfe3NJv7eCo2LEo/P9srf5qs3cmbOqjPo6cLyQpAusY62/hJaHSy2wsYJlPNn
	 rxHi7nk4rKlXD5nLX9GO4A+4M8ZWMJvhbqgnXGla2K6xP3Ax9ftfDWUYKBQ4o8X0XU
	 HexdQTHCzD9mFO9IBqlNpq6uEX8gFll80PT/vg94=
Date: Tue, 28 Oct 2025 14:53:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,mike.kravetz@oracle.com,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,aneesh.kumar@kernel.org,agordeev@linux.ibm.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-fix-hugetlb-vmemmap-optimization-crash.patch added to mm-hotfixes-unstable branch
Message-Id: <20251028215339.D0712C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390: fix HugeTLB vmemmap optimization crash
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     s390-fix-hugetlb-vmemmap-optimization-crash.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-fix-hugetlb-vmemmap-optimization-crash.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Luiz Capitulino <luizcap@redhat.com>
Subject: s390: fix HugeTLB vmemmap optimization crash
Date: Tue, 28 Oct 2025 17:15:33 -0400

A reproducible crash occurs when enabling HugeTLB vmemmap optimization
(HVO) on s390.  The crash and the proposed fix were worked on an s390 KVM
guest running on an older hypervisor, as I don't have access to an LPAR. 
However, the same issue should occur on bare-metal.

Reproducer (it may take a few runs to trigger):

 # sysctl vm.hugetlb_optimize_vmemmap=1
 # echo 1 > /proc/sys/vm/nr_hugepages
 # echo 0 > /proc/sys/vm/nr_hugepages

Crash log:

[   52.340369] list_del corruption. prev->next should be 000000d382110008, but was 000000d7116d3880. (prev=000000d7116d3910)
[   52.340420] ------------[ cut here ]------------
[   52.340424] kernel BUG at lib/list_debug.c:62!
[   52.340566] monitor event: 0040 ilc:2 [#1]SMP
[   52.340573] Modules linked in: ctcm fsm qeth ccwgroup zfcp scsi_transport_fc qdio dasd_fba_mod dasd_eckd_mod dasd_mod xfs ghash_s390 prng des_s390 libdes sha3_512_s390 sha3_256_s390 virtio_net virtio_blk net_failover sha_common failover dm_mirror dm_region_hash dm_log dm_mod paes_s390 crypto_engine pkey_cca pkey_ep11 zcrypt pkey_pckmo pkey aes_s390
[   52.340606] CPU: 1 UID: 0 PID: 1672 Comm: root-rep2 Kdump: loaded Not tainted 6.18.0-rc3 #1 NONE
[   52.340610] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
[   52.340611] Krnl PSW : 0704c00180000000 0000015710cda7fe (__list_del_entry_valid_or_report+0xfe/0x128)
[   52.340619]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[   52.340622] Krnl GPRS: c0000000ffffefff 0000000100000027 000000000000006d 0000000000000000
[   52.340623]            000000d7116d35d8 000000d7116d35d0 0000000000000002 000000d7116d39b0
[   52.340625]            000000d7116d3880 000000d7116d3910 000000d7116d3910 000000d382110008
[   52.340626]            000003ffac1ccd08 000000d7116d39b0 0000015710cda7fa 000000d7116d37d0
[   52.340632] Krnl Code: 0000015710cda7ee: c020003e496f	larl	%r2,00000157114a3acc
           0000015710cda7f4: c0e5ffd5280e	brasl	%r14,000001571077f810
          #0000015710cda7fa: af000000		mc	0,0
          >0000015710cda7fe: b9040029		lgr	%r2,%r9
           0000015710cda802: c0e5ffe5e193	brasl	%r14,0000015710996b28
           0000015710cda808: e34090080004	lg	%r4,8(%r9)
           0000015710cda80e: b9040059		lgr	%r5,%r9
           0000015710cda812: b9040038		lgr	%r3,%r8
[   52.340643] Call Trace:
[   52.340645]  [<0000015710cda7fe>] __list_del_entry_valid_or_report+0xfe/0x128
[   52.340649] ([<0000015710cda7fa>] __list_del_entry_valid_or_report+0xfa/0x128)
[   52.340652]  [<0000015710a30b2e>] hugetlb_vmemmap_restore_folios+0x96/0x138
[   52.340655]  [<0000015710a268ac>] update_and_free_pages_bulk+0x64/0x150
[   52.340659]  [<0000015710a26f8a>] set_max_huge_pages+0x4ca/0x6f0
[   52.340662]  [<0000015710a273ba>] hugetlb_sysctl_handler_common+0xea/0x120
[   52.340665]  [<0000015710a27484>] hugetlb_sysctl_handler+0x44/0x50
[   52.340667]  [<0000015710b53ffa>] proc_sys_call_handler+0x17a/0x280
[   52.340672]  [<0000015710a90968>] vfs_write+0x2c8/0x3a0
[   52.340676]  [<0000015710a90bd2>] ksys_write+0x72/0x100
[   52.340679]  [<00000157111483a8>] __do_syscall+0x150/0x318
[   52.340682]  [<0000015711153a5e>] system_call+0x6e/0x90
[   52.340684] Last Breaking-Event-Address:
[   52.340684]  [<000001571077f85c>] _printk+0x4c/0x58
[   52.340690] Kernel panic - not syncing: Fatal exception: panic_on_oops

This issue was introduced by commit f13b83fdd996 ("hugetlb: batch TLB
flushes when freeing vmemmap").  Before that change, the HVO
implementation called flush_tlb_kernel_range() each time a vmemmap PMD
split and remapping was performed.  The mentioned commit changed this to
issue a few flush_tlb_all() calls after performing all remappings.

However, on s390, flush_tlb_kernel_range() expands to __tlb_flush_kernel()
while flush_tlb_all() is not implemented.  As a result, we went from
flushing the TLB for every remapping to no flushing at all.

This commit fixes this by implementing flush_tlb_all() on s390 as an alias
to __tlb_flush_global().  This should cause a flush on all TLB entries on
all CPUs as expected by the flush_tlb_all() semantics.

Link: https://lkml.kernel.org/r/20251028211533.47694-1-luizcap@redhat.com
Fixes: f13b83fdd996 ("hugetlb: batch TLB flushes when freeing vmemmap")
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/tlbflush.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/s390/include/asm/tlbflush.h~s390-fix-hugetlb-vmemmap-optimization-crash
+++ a/arch/s390/include/asm/tlbflush.h
@@ -103,9 +103,13 @@ static inline void __tlb_flush_mm_lazy(s
  * flush_tlb_range functions need to do the flush.
  */
 #define flush_tlb()				do { } while (0)
-#define flush_tlb_all()				do { } while (0)
 #define flush_tlb_page(vma, addr)		do { } while (0)
 
+static inline void flush_tlb_all(void)
+{
+	__tlb_flush_global();
+}
+
 static inline void flush_tlb_mm(struct mm_struct *mm)
 {
 	__tlb_flush_mm_lazy(mm);
_

Patches currently in -mm which might be from luizcap@redhat.com are

s390-fix-hugetlb-vmemmap-optimization-crash.patch

