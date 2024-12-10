Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E3CAD5A
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 03:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733802166; cv=none; b=TpmKdbhSGcHc+kerXlMNvHRwbOqFKJ/72EmXQ3vPjcHw5hznldDdzkvntc1G23AlIy9tgd3PFl5Ao5ewZ51IXPlVwwhbH+Efpa7JmDHqFlD6dLxcK8kqkIlLwpYmC2+XEmaLLbYoD8iKvWu3pfCDBLharodC4DI1bOCscl+QYag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733802166; c=relaxed/simple;
	bh=rel63ctHyXqQ6/fHhl9v+ac5NnAXP8u3rHPqhhO4eK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GYo0Nj/r5G3yDzXNu6wV9eSw1fkOlREDUj4UvXbWgTSu1J2dYMYTcGkITLR1ltsulWxA9euFMScv/DX+kzd38iFNp6IWqFPrA72/dqeN+noOHGOAxVUyjiSfHwnsu/4FnDUWufzbdYmdRYktSP6u2Gecaf12JOZz8crKbRlepDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DFE8113E;
	Mon,  9 Dec 2024 19:43:11 -0800 (PST)
Received: from [10.163.48.173] (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0D653F720;
	Mon,  9 Dec 2024 19:42:41 -0800 (PST)
Message-ID: <7627f30c-d68f-486c-b236-3bb78c4c46c5@arm.com>
Date: Tue, 10 Dec 2024 09:12:39 +0530
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-execmem-make-arch_wants_execmem_late-depend-on-execmem.patch
 added to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 will@kernel.org, kees@kernel.org, catalin.marinas@arm.com
References: <20241210031044.23B8FC4CED1@smtp.kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20241210031044.23B8FC4CED1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/24 08:40, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/execmem: make ARCH_WANTS_EXECMEM_LATE depend on EXECMEM
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-execmem-make-arch_wants_execmem_late-depend-on-execmem.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-execmem-make-arch_wants_execmem_late-depend-on-execmem.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> Subject: mm/execmem: make ARCH_WANTS_EXECMEM_LATE depend on EXECMEM
> Date: Mon, 9 Dec 2024 08:42:51 +0530
> 
> Late initialisation of EXECMEM inherently requires EXECMEM itself, and
> hence this dependency should not be left with the subscribing platforms.
> 
> Link: https://lkml.kernel.org/r/20241209031251.515903-1-anshuman.khandual@arm.com
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/Kconfig       |    1 +
>  arch/arm64/Kconfig |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/arch/arm64/Kconfig~mm-execmem-make-arch_wants_execmem_late-depend-on-execmem
> +++ a/arch/arm64/Kconfig
> @@ -113,7 +113,7 @@ config ARM64
>  	select ARCH_WANT_FRAME_POINTERS
>  	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
>  	select ARCH_WANT_LD_ORPHAN_WARN
> -	select ARCH_WANTS_EXECMEM_LATE if EXECMEM
> +	select ARCH_WANTS_EXECMEM_LATE
>  	select ARCH_WANTS_NO_INSTR
>  	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
>  	select ARCH_HAS_UBSAN
> --- a/arch/Kconfig~mm-execmem-make-arch_wants_execmem_late-depend-on-execmem
> +++ a/arch/Kconfig
> @@ -1058,6 +1058,7 @@ config ARCH_WANTS_MODULES_DATA_IN_VMALLO
>  
>  config ARCH_WANTS_EXECMEM_LATE
>  	bool
> +	depends on EXECMEM
>  	help
>  	  For architectures that do not allocate executable memory early on
>  	  boot, but rather require its initialization late when there is
> _
> 
> Patches currently in -mm which might be from anshuman.khandual@arm.com are
> 
> mm-execmem-make-arch_wants_execmem_late-depend-on-execmem.patch
> 

Hello Andrew,

As Catalin has explained earlier on the thread, we might just need
to drop the EXECMEM dependency in the platform, and not change the
generic config definition. Hence this patch needs some change.

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5479c8b454c..b146372bc365 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -113,7 +113,7 @@ config ARM64
        select ARCH_WANT_FRAME_POINTERS
        select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
        select ARCH_WANT_LD_ORPHAN_WARN
-       select ARCH_WANTS_EXECMEM_LATE if EXECMEM
+       select ARCH_WANTS_EXECMEM_LATE
        select ARCH_WANTS_NO_INSTR
        select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
        select ARCH_HAS_UBSAN

- Anshuman
