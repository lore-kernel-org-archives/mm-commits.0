Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BEE1F5EA;
	Tue, 21 Oct 2025 06:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761026561; cv=none; b=mrrONX81mtADxPUabBfxeuyWObmWtXvRa/XP2xfD2fOOgyOYMlPdieCBhod3yrwuF6vF27TbU0Z2zpsWvZP/2MALcw0dM0qs0hg86uWV6eep+V/z/w4u/07/xGcSWPUONcCu0/hVexlYlATMxMTHBNk5QaJ5jrJgGjWQxnRk5w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761026561; c=relaxed/simple;
	bh=UtM24LBw0kofOTgc1QtR+H0svFZ+FPwtIYWVWuHPnnc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OyOhHyfVD+BaXwIZneWEcEaK05ZjrzQJk5pwuRD6X/WqGVgu1SSj2omHLw7XEOaJxfMkadEWDNSBgKcEcJ9M2GeosBGgxQ8y9X4hGdX7QSiN8nsisxr90ath4tSMy9+elJ0lWr2rJxsgxRjTsV8klqh/FXU89erTIrx1zpi9XV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hinwa3Ks; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hinwa3Ks"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L0b7Fc027573;
	Tue, 21 Oct 2025 06:02:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IjvYYX
	wFHBFwYJzsKvgtttHEn+x6uLowqynQy5g3kx0=; b=hinwa3KsGM6Ugf0T4po25h
	fm8Z1031bkYEHfxtA2TlM8ZyEqduwXL1bl29mRUuzZODX6Mm2/q2IIIatf564/4K
	i5k7bKK9oySQVhAjZswJwL90GvPXFCiyc/ilqszXSQIL2HIV6tIUCfP/RRd/okMq
	O02W4wI2/UmOi+zcT384vUxKQ8WXNgRk2t+bQqM/nVKenl5Qt22tx9UAhn0nW/RQ
	5j+sa+QI8/vspzbPzXmujXQxAKIOqxvIO7bd6OeZYSdy+4llX/yjsNF0IrMHc8p7
	PLODIsTnevcTiFDcdUMemvcimrHaoMmE1oIaYGk1qMNhMvBgoz8gMfn8aWvffhFQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31rwajq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 06:02:27 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59L62Rlq023601;
	Tue, 21 Oct 2025 06:02:27 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31rwajk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 06:02:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59L3vfTZ002926;
	Tue, 21 Oct 2025 06:02:26 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqej93mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 06:02:26 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59L62PZn9241520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 06:02:25 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1355C5805D;
	Tue, 21 Oct 2025 06:02:25 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DBFB658043;
	Tue, 21 Oct 2025 06:02:19 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.61.240.251])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Oct 2025 06:02:19 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Re: +
 crash-let-architecture-decide-crash-memory-export-to-iomem_resource.patch
 added to mm-nonmm-unstable branch
From: Venkat <venkat88@linux.ibm.com>
In-Reply-To: <20251016195042.D8570C4CEF9@smtp.kernel.org>
Date: Tue, 21 Oct 2025 11:32:06 +0530
Cc: mm-commits@vger.kernel.org, vgoyal@redhat.com, stable@vger.kernel.org,
        rppt@kernel.org, ritesh.list@gmail.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Hari Bathini <hbathini@linux.ibm.com>, dyoung@redhat.com,
        bhe@redhat.com, Sourabh Jain <sourabhjain@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <14D10834-DD07-4F14-B182-6423B8C7A9BE@linux.ibm.com>
References: <20251016195042.D8570C4CEF9@smtp.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3774.600.62)
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A8xGDCgOD79lJ0pB6mlVoh5MuZ10iX_C
X-Proofpoint-GUID: KnRttpubXfkkPGgdspqaSsRxuHTgAe30
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX9RRvuCy6UJfT
 I/hS8dTyqpF7pwNw9sUhD3KVbRllbv83MZTBBJzSRRyuzeC4Iz6A5aiv8AQiPiEK70fovl7NxLW
 isT+sEXFxy0ouXGtkiucJnYLquJrtCCL6pZpMVf9Ci4JvS9v7DqFOuWFwBXLVps3ZPcbWOqhbAm
 d0/T+ehA9ab0SNot7yhVAly1y31y00z6z7gm6R7SObqJU7wY9EsbaFY9wNrdK/GrlsEeh1mrFjw
 W1WGMsWcCi7sQORV5wVcWYNkmCYr5Ece0hAlctuWjgRxQste5+QVgJyaq1h/P7DXLthahR7vEp/
 C2MKdmciCj60FNSfkR6T9jXNuLhTPoyQtDTg4ka2Rwsxuy00AhWOLAfUQNkXsY/r6ELB+o41Tba
 +c/fH5lW7t1HvhS1wxpSazVdNjIIiw==
X-Authority-Analysis: v=2.4 cv=IJYPywvG c=1 sm=1 tr=0 ts=68f721f3 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8
 a=pGLkceISAAAA:8 a=qCpo0lJxKfPyk4X55hgA:9 a=QEXdDO2ut3YA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022



> On 17 Oct 2025, at 1:20=E2=80=AFAM, Andrew Morton =
<akpm@linux-foundation.org> wrote:
>=20
>=20
> The patch titled
>     Subject: crash: let architecture decide crash memory export to =
iomem_resource
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>     =
crash-let-architecture-decide-crash-memory-export-to-iomem_resource.patch
>=20
> This patch will shortly appear at
>     =
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patch=
es/crash-let-architecture-decide-crash-memory-export-to-iomem_resource.pat=
ch
>=20
> This patch will later appear in the mm-nonmm-unstable branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>=20
> Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>=20
> *** Remember to use Documentation/process/submit-checklist.rst when =
testing your code ***
>=20
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>=20
> ------------------------------------------------------
> From: Sourabh Jain <sourabhjain@linux.ibm.com>
> Subject: crash: let architecture decide crash memory export to =
iomem_resource
> Date: Thu, 16 Oct 2025 19:58:31 +0530
>=20
> With the generic crashkernel reservation, the kernel emits the =
following
> warning on powerpc:
>=20
> WARNING: CPU: 0 PID: 1 at arch/powerpc/mm/mem.c:341 =
add_system_ram_resources+0xfc/0x180
> Modules linked in:
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted =
6.17.0-auto-12607-g5472d60c129f #1 VOLUNTARY
> Hardware name: IBM,9080-HEX Power11 (architected) 0x820200 0xf000007 =
of:IBM,FW1110.01 (NH1110_069) hv:phyp pSeries
> NIP:  c00000000201de3c LR: c00000000201de34 CTR: 0000000000000000
> REGS: c000000127cef8a0 TRAP: 0700   Not tainted =
(6.17.0-auto-12607-g5472d60c129f)
> MSR:  8000000002029033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 84000840  XER: =
20040010
> CFAR: c00000000017eed0 IRQMASK: 0
> GPR00: c00000000201de34 c000000127cefb40 c0000000016a8100 =
0000000000000001
> GPR04: c00000012005aa00 0000000020000000 c000000002b705c8 =
0000000000000000
> GPR08: 000000007fffffff fffffffffffffff0 c000000002db8100 =
000000011fffffff
> GPR12: c00000000201dd40 c000000002ff0000 c0000000000112bc =
0000000000000000
> GPR16: 0000000000000000 0000000000000000 0000000000000000 =
0000000000000000
> GPR20: 0000000000000000 0000000000000000 0000000000000000 =
c0000000015a3808
> GPR24: c00000000200468c c000000001699888 0000000000000106 =
c0000000020d1950
> GPR28: c0000000014683f8 0000000081000200 c0000000015c1868 =
c000000002b9f710
> NIP [c00000000201de3c] add_system_ram_resources+0xfc/0x180
> LR [c00000000201de34] add_system_ram_resources+0xf4/0x180
> Call Trace:
> add_system_ram_resources+0xf4/0x180 (unreliable)
> do_one_initcall+0x60/0x36c
> do_initcalls+0x120/0x220
> kernel_init_freeable+0x23c/0x390
> kernel_init+0x34/0x26c
> ret_from_kernel_user_thread+0x14/0x1c
>=20
> This warning occurs due to a conflict between crashkernel and System =
RAM
> iomem resources.
>=20
> The generic crashkernel reservation adds the crashkernel memory range =
to
> /proc/iomem during early initialization. Later, all memblock ranges =
are
> added to /proc/iomem as System RAM. If the crashkernel region overlaps
> with any memblock range, it causes a conflict while adding those =
memblock
> regions as iomem resources, triggering the above warning. The =
conflicting
> memblock regions are then omitted from /proc/iomem.
>=20
> For example, if the following crashkernel region is added to =
/proc/iomem:
> 20000000-11fffffff : Crash kernel
>=20
> then the following memblock regions System RAM regions fail to be =
inserted:
> 00000000-7fffffff : System RAM
> 80000000-257fffffff : System RAM
>=20
> Fix this by not adding the crashkernel memory to /proc/iomem on =
powerpc.
> Introduce an architecture hook to let each architecture decide whether =
to
> export the crashkernel region to /proc/iomem.
>=20
> For more info checkout commit c40dd2f766440 ("powerpc: Add System RAM
> to /proc/iomem") and commit bce074bdbc36 ("powerpc: insert System RAM
> resource to prevent crashkernel conflict")
>=20
> Note: Before switching to the generic crashkernel reservation, powerpc
> never exported the crashkernel region to /proc/iomem.
>=20
> Link: =
https://lkml.kernel.org/r/20251016142831.144515-1-sourabhjain@linux.ibm.co=
m
> Fixes: e3185ee438c2 ("powerpc/crash: use generic crashkernel =
reservation").
> Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Closes: =
https://lore.kernel.org/all/90937fe0-2e76-4c82-b27e-7b8a7fe3ac69@linux.ibm=
.com/
> Cc: Baoquan he <bhe@redhat.com>
> Cc: Hari Bathini <hbathini@linux.ibm.com>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Tested this patch by applying on the mainline kernel, and it fixes =
reported issue. Please add below tag.

Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>

Regards,
Venkat.
>=20
> arch/powerpc/include/asm/crash_reserve.h |    8 ++++++++
> include/linux/crash_reserve.h            |    6 ++++++
> kernel/crash_reserve.c                   |    3 +++
> 3 files changed, 17 insertions(+)
>=20
> --- =
a/arch/powerpc/include/asm/crash_reserve.h~crash-let-architecture-decide-c=
rash-memory-export-to-iomem_resource
> +++ a/arch/powerpc/include/asm/crash_reserve.h
> @@ -5,4 +5,12 @@
> /* crash kernel regions are Page size agliged */
> #define CRASH_ALIGN             PAGE_SIZE
>=20
> +#ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
> +static inline bool arch_add_crash_res_to_iomem(void)
> +{
> + return false;
> +}
> +#define arch_add_crash_res_to_iomem arch_add_crash_res_to_iomem
> +#endif
> +
> #endif /* _ASM_POWERPC_CRASH_RESERVE_H */
> --- =
a/include/linux/crash_reserve.h~crash-let-architecture-decide-crash-memory=
-export-to-iomem_resource
> +++ a/include/linux/crash_reserve.h
> @@ -32,6 +32,12 @@ int __init parse_crashkernel(char *cmdli
> void __init reserve_crashkernel_cma(unsigned long long cma_size);
>=20
> #ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
> +#ifndef arch_add_crash_res_to_iomem
> +static inline bool arch_add_crash_res_to_iomem(void)
> +{
> + return true;
> +}
> +#endif
> #ifndef DEFAULT_CRASH_KERNEL_LOW_SIZE
> #define DEFAULT_CRASH_KERNEL_LOW_SIZE (128UL << 20)
> #endif
> --- =
a/kernel/crash_reserve.c~crash-let-architecture-decide-crash-memory-export=
-to-iomem_resource
> +++ a/kernel/crash_reserve.c
> @@ -524,6 +524,9 @@ void __init reserve_crashkernel_cma(unsi
> #ifndef HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
> static __init int insert_crashkernel_resources(void)
> {
> + if (!arch_add_crash_res_to_iomem())
> + return 0;
> +
> if (crashk_res.start < crashk_res.end)
> insert_resource(&iomem_resource, &crashk_res);
>=20
> _
>=20
> Patches currently in -mm which might be from sourabhjain@linux.ibm.com =
are
>=20
> =
crash-let-architecture-decide-crash-memory-export-to-iomem_resource.patch
>=20

