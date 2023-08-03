Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53BAEC04A6A
	for <mm-commits@archiver.kernel.org>; Thu,  3 Aug 2023 15:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbjHCPIm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Aug 2023 11:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjHCPIl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2023 11:08:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFED0E72;
        Thu,  3 Aug 2023 08:08:40 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 373ExfHk012347;
        Thu, 3 Aug 2023 15:05:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=IYiuovnfCBxBU6H9Y4kbtmrdnbXDtHZORCIidCy7rRY=;
 b=qTVBzynwCiVs1wO2pvwx1HLbD6PI6c1dVjdpblkXK+zFMuJtyL22pgdnR4mVUpbHSi28
 IUVOiNYDJp7EwT/CeJ6STpWaD5ZMuPV+6iMnezvJGKAO0mONaljSZRrnhJBe4ei7K6hw
 XMRrIbr2lWG3JqynvRnps4cXDhFrarOz+Q0hlB9MeoaXA9q96q1jYpoq46zkyP448NCt
 6gF2t48uyqAdtXbx3VtKnmSaiuVJmaoWyf9e8DmpgTlTlXN3CIRtoI9Yp9w2CkaKjfsP
 G4iTuWZ4aWcA/Prua/OGa4mBQmQMIE0VanOk8RyEUNef3RZuuKhSeJiFuu75ZECNM6Kz Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s8efxr991-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Aug 2023 15:05:25 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 373F0Guu014265;
        Thu, 3 Aug 2023 15:05:24 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s8efxr97q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Aug 2023 15:05:24 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 373D13iT017033;
        Thu, 3 Aug 2023 15:05:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s5dfypmhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Aug 2023 15:05:21 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 373F5IPu45351468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Aug 2023 15:05:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0EC020043;
        Thu,  3 Aug 2023 15:05:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4200D20040;
        Thu,  3 Aug 2023 15:05:17 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  3 Aug 2023 15:05:17 +0000 (GMT)
Date:   Thu, 3 Aug 2023 17:05:15 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Eric DeVolder <eric.devolder@oracle.com>
Cc:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-s390@vger.kernel.org, ziy@nvidia.com,
        ysato@users.sourceforge.jp, xin3.li@intel.com, will@kernel.org,
        tsi@tuyoix.net, tsbogend@alpha.franken.de, tj@kernel.org,
        thunder.leizhen@huawei.com, tglx@linutronix.de,
        svens@linux.ibm.com, sourabhjain@linux.ibm.com,
        sebastian.reichel@collabora.com, samitolvanen@google.com,
        rppt@kernel.org, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
        paul.walmsley@sifive.com, paulmck@kernel.org, palmer@dabbelt.com,
        ojeda@kernel.org, npiggin@gmail.com, ndesaulniers@google.com,
        mpe@ellerman.id.au, mingo@redhat.com, mhiramat@kernel.org,
        masahiroy@kernel.org, linux@armlinux.org.uk,
        linux.walleij@linaro.org, konrad.wilk@oracle.com,
        kirill.shutemov@linux.intel.com, kernel@xen0n.name,
        keescook@chromium.org, juerg.haefliger@canonical.com,
        James.Bottomley@hansenpaternship.com, hpa@zytor.com,
        hca@linux.ibm.com, hbathini@linux.ibm.com,
        gregkh@linuxfoundation.org, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        frederic@kernel.org, deller@gmx.de, dave.hansen@linux.intel.com,
        dal.ias@libc.org, christophe.leroy@csgroup.eu,
        chenhuacai@kernel.org, catalin.marinas@arm.com, bp@alien8.de,
        borntraeger@linux.ibm.com, boris.ostrovsky@oracle.com,
        bhe@redhat.com, arnd@arndb.de, ardb@kernel.org,
        aou@eecs.gerkeley.edu, anshuman.khandual@arm.com
Subject: Re: [PATCH] remove ARCH_DEFAULT_KEXEC from Kconfig.kexec
Message-ID: <ZMvCK7BcLmC9rWH4@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20230802161750.2215-1-eric.devolder@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802161750.2215-1-eric.devolder@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gFmAKea5phcOZO_EJ9vmyEtCG5D10_nP
X-Proofpoint-ORIG-GUID: -Q9IY0qa6MU0lqx6ujsmQBVKRCC6jlqD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-03_14,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 phishscore=0 mlxscore=0
 mlxlogscore=966 adultscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308030131
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Aug 02, 2023 at 12:17:50PM -0400, Eric DeVolder wrote:
> This patch is a minor cleanup to the series "refactor Kconfig to
> consolidate KEXEC and CRASH options".
> 
> In that series, a new option ARCH_DEFAULT_KEXEC was introduced in
> order to obtain the equivalent behavior of s390 original Kconfig
> settings for KEXEC. As it turns out, this new option did not fully
> provide the equivalent behavior, rather a "select KEXEC" did.
> 
> As such, the ARCH_DEFAULT_KEXEC is not needed anymore, so remove it.
> 
> Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
> ---
>  arch/s390/Kconfig    | 3 ---
>  kernel/Kconfig.kexec | 1 -
>  2 files changed, 4 deletions(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 42c98931de2c..c9e523e0d997 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -246,9 +246,6 @@ config PGTABLE_LEVELS
>  
>  source "kernel/livepatch/Kconfig"
>  
> -config ARCH_DEFAULT_KEXEC
> -	def_bool y
> -
>  config ARCH_SUPPORTS_KEXEC
>  	def_bool y
>  
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index ff72e45cfaef..701cd5336f4f 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -17,7 +17,6 @@ config HAVE_IMA_KEXEC
>  
>  config KEXEC
>  	bool "Enable kexec system call"
> -	default ARCH_DEFAULT_KEXEC
>  	depends on ARCH_SUPPORTS_KEXEC
>  	select KEXEC_CORE
>  	help

For s390:

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
