Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA951E1C36;
	Thu,  8 May 2025 06:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746684092; cv=none; b=R1lAA3apfNuKjoNtGk27iQ9nOeo9zX3Fph0uIiOruDNv7j2ANrGwwSwHYCMWXq21zrPKQpSxxfBuCAv2Ujiuj7c8eyPNIvcg/Bn+TQEXSLfjx2EPVTijkZsWa3riM2zQvbYsSdr0fajiRzzHIYDsnx+1tG0G/ZRavcVT+/Dj3bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746684092; c=relaxed/simple;
	bh=KWAetSLSEDSh0aoG4cvEJlIBqaDMkxzrcH5lNsLiKXo=;
	h=Date:To:From:Subject:Message-Id; b=opp2eg9NK4xj/601bB55dj1VKRXfxTe/qY7LCGIXBOEs6/pw5QUxTVdGb4BzEOWb3Wox51M00NPtyL8B8TKuIhYaV6UrMdkozLPLrKFzzSwVwK0bExDsaDQWvLHBkhUIC1W/rg59X8hfQRQsH0urAiD6nMd1nRsgDZQNgL47/NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EIz0QOVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EIz0QOVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9600C4CEEB;
	Thu,  8 May 2025 06:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746684091;
	bh=KWAetSLSEDSh0aoG4cvEJlIBqaDMkxzrcH5lNsLiKXo=;
	h=Date:To:From:Subject:From;
	b=EIz0QOVKJYJ/kfI7PMWbr1R/WpkdYEL6PA7WEf+UE0hwd7Nv2i23QSEPfnao/cM2h
	 TDQTuxA8gEqua8uFlFIGKaWLWHwVrMY2LdCYtValKib5eQSmVVvRUFzUJJHbZgkpA/
	 KnMal6G5uRaM5QDaIp5OFGT4BQUJp+rLrBv9ShNU=
Date: Wed, 07 May 2025 23:01:31 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,vgoyal@redhat.com,stable@vger.kernel.org,dyoung@redhat.com,coxu@redhat.com,bhe@redhat.com,fuqiang.wang@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-fix-potential-cmem-ranges-out-of-bounds.patch added to mm-hotfixes-unstable branch
Message-Id: <20250508060131.D9600C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kexec: fix potential cmem->ranges out of bounds
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-kexec-fix-potential-cmem-ranges-out-of-bounds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-fix-potential-cmem-ranges-out-of-bounds.patch

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
From: fuqiang wang <fuqiang.wang@easystack.cn>
Subject: x86/kexec: fix potential cmem->ranges out of bounds
Date: Mon, 8 Jan 2024 21:06:47 +0800

In memmap_exclude_ranges(), elfheader will be excluded from crashk_res.
In the current x86 architecture code, the elfheader is always allocated
at crashk_res.start. It seems that there won't be a new split range.
But it depends on the allocation position of elfheader in crashk_res. To
avoid potential out of bounds in future, add a extra slot.

The similar issue also exists in fill_up_crash_elf_data(). The range to
be excluded is [0, 1M], start (0) is special and will not appear in the
middle of existing cmem->ranges[]. But in cast the low 1M could be
changed in the future, add a extra slot too.

Without this patch, kdump kernel will fail to be loaded by
kexec_file_load,

  [  139.736948] UBSAN: array-index-out-of-bounds in arch/x86/kernel/crash.c:350:25
  [  139.742360] index 0 is out of range for type 'range [*]'
  [  139.745695] CPU: 0 UID: 0 PID: 5778 Comm: kexec Not tainted 6.15.0-0.rc3.20250425git02ddfb981de8.32.fc43.x86_64 #1 PREEMPT(lazy) 
  [  139.745698] Hardware name: Amazon EC2 c5.large/, BIOS 1.0 10/16/2017
  [  139.745699] Call Trace:
  [  139.745700]  <TASK>
  [  139.745701]  dump_stack_lvl+0x5d/0x80
  [  139.745706]  ubsan_epilogue+0x5/0x2b
  [  139.745709]  __ubsan_handle_out_of_bounds.cold+0x54/0x59
  [  139.745711]  crash_setup_memmap_entries+0x2d9/0x330
  [  139.745716]  setup_boot_parameters+0xf8/0x6a0
  [  139.745720]  bzImage64_load+0x41b/0x4e0
  [  139.745722]  ? find_next_iomem_res+0x109/0x140
  [  139.745727]  ? locate_mem_hole_callback+0x109/0x170
  [  139.745737]  kimage_file_alloc_init+0x1ef/0x3e0
  [  139.745740]  __do_sys_kexec_file_load+0x180/0x2f0
  [  139.745742]  do_syscall_64+0x7b/0x160
  [  139.745745]  ? do_user_addr_fault+0x21a/0x690
  [  139.745747]  ? exc_page_fault+0x7e/0x1a0
  [  139.745749]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [  139.745751] RIP: 0033:0x7f7712c84e4d


Previously discussed link:
[1] https://lore.kernel.org/kexec/ZXk2oBf%2FT1Ul6o0c@MiWiFi-R3L-srv/
[2] https://lore.kernel.org/kexec/273284e8-7680-4f5f-8065-c5d780987e59@easystack.cn/
[3] https://lore.kernel.org/kexec/ZYQ6O%2F57sHAPxTHm@MiWiFi-R3L-srv/

Link: https://lkml.kernel.org/r/20240108130720.228478-1-fuqiang.wang@easystack.cn
Signed-off-by: fuqiang wang <fuqiang.wang@easystack.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Reported-by: Coiby Xu <coxu@redhat.com>
Closes: https://lkml.kernel.org/r/4de3c2onosr7negqnfhekm4cpbklzmsimgdfv33c52dktqpza5@z5pb34ghz4at
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: <x86@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/crash.c~x86-kexec-fix-potential-cmem-ranges-out-of-bounds
+++ a/arch/x86/kernel/crash.c
@@ -165,8 +165,18 @@ static struct crash_mem *fill_up_crash_e
 	/*
 	 * Exclusion of crash region and/or crashk_low_res may cause
 	 * another range split. So add extra two slots here.
+	 *
+	 * Exclusion of low 1M may not cause another range split, because the
+	 * range of exclude is [0, 1M] and the condition for splitting a new
+	 * region is that the start, end parameters are both in a certain
+	 * existing region in cmem and cannot be equal to existing region's
+	 * start or end. Obviously, the start of [0, 1M] cannot meet this
+	 * condition.
+	 *
+	 * But in order to lest the low 1M could be changed in the future,
+	 * (e.g. [stare, 1M]), add a extra slot.
 	 */
-	nr_ranges += 2;
+	nr_ranges += 3;
 	cmem = vzalloc(struct_size(cmem, ranges, nr_ranges));
 	if (!cmem)
 		return NULL;
@@ -298,9 +308,16 @@ int crash_setup_memmap_entries(struct ki
 	struct crash_memmap_data cmd;
 	struct crash_mem *cmem;
 
-	cmem = vzalloc(struct_size(cmem, ranges, 1));
+	/*
+	 * In the current x86 architecture code, the elfheader is always
+	 * allocated at crashk_res.start. But it depends on the allocation
+	 * position of elfheader in crashk_res. To avoid potential out of
+	 * bounds in future, add a extra slot.
+	 */
+	cmem = vzalloc(struct_size(cmem, ranges, 2));
 	if (!cmem)
 		return -ENOMEM;
+	cmem->max_nr_ranges = 2;
 
 	memset(&cmd, 0, sizeof(struct crash_memmap_data));
 	cmd.params = params;
_

Patches currently in -mm which might be from fuqiang.wang@easystack.cn are

x86-kexec-fix-potential-cmem-ranges-out-of-bounds.patch

