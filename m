From: akpm@linux-foundation.org
Subject: + vmcoreinfo-fix-the-configuration-dependencies-fix.patch added to -mm tree
Date: Tue, 27 Nov 2007 02:10:34 -0800
Message-ID: <200711271010.lARAAY9V006210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbXK0KKt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 05:10:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, rientjes@google.com


The patch titled
     vmcoreinfo-fix-the-configuration-dependencies fix
has been added to the -mm tree.  Its filename is
     vmcoreinfo-fix-the-configuration-dependencies-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmcoreinfo-fix-the-configuration-dependencies fix
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

Hi Andrew,

Andrew Morton wrote:
>> diff -rpuN a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
>> --- a/arch/x86/kernel/machine_kexec_64.c	2007-11-14 15:39:19.000000000 +0900
>> +++ b/arch/x86/kernel/machine_kexec_64.c	2007-11-14 15:39:33.000000000 +0900
>> @@ -235,7 +235,7 @@ void arch_crash_save_vmcoreinfo(void)
>>  {
>>  	VMCOREINFO_SYMBOL(init_level4_pgt);
>>
>> -#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
>> +#ifdef CONFIG_NUMA
>>  	VMCOREINFO_SYMBOL(node_data);
>>  	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
>>  #endif
>> _
>>
>
> x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch removes the
> `VMCOREINFO_SYMBOL(node_data);' from arch/x86/kernel/machine_kexec_64.c
> altogether, so I dropped that part of your patch.

The above part is necessary for a NUMA kernel.
Could you please merge the attached patch ?

I guess that Christoph Lameter deleted the above part (which is added
by the attached patch again) with the other part of discontigmem lines,
because it depended on CONFIG_ARCH_DISCONTIGMEM_ENABLE.
But the dependency was wrong, and it should depend on CONFIG_NUMA.
The part is necessary for a NUMA kernel even if sparsemem.

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Cc: Simon Horman <horms@verge.net.au>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/x86/kernel/machine_kexec_64.c~vmcoreinfo-fix-the-configuration-dependencies-fix arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~vmcoreinfo-fix-the-configuration-dependencies-fix
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -234,5 +234,10 @@ NORET_TYPE void machine_kexec(struct kim
 void arch_crash_save_vmcoreinfo(void)
 {
 	VMCOREINFO_SYMBOL(init_level4_pgt);
+
+#ifdef CONFIG_NUMA
+	VMCOREINFO_SYMBOL(node_data);
+	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
+#endif
 }
 
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size.patch
vmcoreinfo-use-the-existing-offsetof-for-vmcoreinfo_offset.patch
vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str.patch
vmcoreinfo-fix-the-configuration-dependencies.patch
vmcoreinfo-fix-the-configuration-dependencies-fix.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch
