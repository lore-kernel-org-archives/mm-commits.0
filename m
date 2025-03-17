Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938DC17995E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 17:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742232923; cv=none; b=jqFkAxFv9+ExaeJ0rBJ5Yzm/qtM+Vxdtuefujwlnt5kQK8NMdlyzVIp31XrF0hvyvlmij7cHpqFR1ZyhlD0RRiLcY/XEfUHRzYqDeqVjACER3w+Yb0Z1ntC5mXZf5DY5nhKLrJKR20IUHEzKIGrqraDKx5H2/Lc2TLJ2Jp+ffQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742232923; c=relaxed/simple;
	bh=vln4a5xdTCHQIbH/AZTQVx96hAWrVnr/SGV4MT5lHUs=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HSRRX177XnzzEkFlja5Zx5yFxAAc1CcK78Q/XLFuXj3ATmUhF2Uukh+eIQbvvwo8PQ7ETxtKL3VccSEPvWSu0ELW/0f31B30fP4/B67C1A5pREKmWZ7rRxnwrV8nIXpZKCu/EhLKKXBiCSQcql8JV36j+5s5TGDtPGbZmJQIRFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=IdQI76A+; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="IdQI76A+"
Received: from [100.65.233.190] (unknown [20.236.11.185])
	by linux.microsoft.com (Postfix) with ESMTPSA id 097702033441;
	Mon, 17 Mar 2025 10:35:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 097702033441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1742232922;
	bh=hCYT89b7jv62v6lju8lusXnXQbegYwkKtVtnz1RYUiw=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=IdQI76A+sMKj74FNLFuI7uheCS0fAWERWu043gYw7zpKT7kUlzt/apawpkf+qsn+K
	 nS708kH7ssX3e+jJm3ZXrZZjeQz3BFxhqplCtPzvGtYrKV1uwU9cIgnX0oLj3FhvEz
	 VWxkl8O6Z29kiatMU37XqAAL5/RwdaCS+0mjvKlo=
Message-ID: <843db43a-9a7d-4f90-9532-47c31e231016@linux.microsoft.com>
Date: Mon, 17 Mar 2025 10:35:28 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: mm-commits@vger.kernel.org, idryomov@gmail.com, axboe@kernel.dk,
 eahariha@linux.microsoft.com, "Martin K. Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [merged mm-nonmm-stable]
 libceph-convert-timeouts-to-secs_to_jiffies.patch removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
References: <20250317053231.84315C4CEEC@smtp.kernel.org>
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Content-Language: en-US
In-Reply-To: <20250317053231.84315C4CEEC@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/16/2025 10:32 PM, Andrew Morton wrote:
> The quilt patch titled
>      Subject: libceph: convert timeouts to secs_to_jiffies()
> has been removed from the -mm tree.  Its filename was
>      libceph-convert-timeouts-to-secs_to_jiffies.patch
> 
> This patch was dropped because it was merged into the mm-nonmm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Easwar Hariharan <eahariha@linux.microsoft.com>
> Subject: libceph: convert timeouts to secs_to_jiffies()
> Date: Tue, 25 Feb 2025 20:17:21 +0000
> 
> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
> secs_to_jiffies().  As the value here is a multiple of 1000, use
> secs_to_jiffies() instead of msecs_to_jiffies() to avoid the
> multiplication
> 
> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
> the following Coccinelle rules:
> 
> @depends on patch@ expression E; @@
> 
> -msecs_to_jiffies(E * 1000)
> +secs_to_jiffies(E)
> 
> @depends on patch@ expression E; @@
> 
> -msecs_to_jiffies(E * MSEC_PER_SEC)
> +secs_to_jiffies(E)
> 
> While here, remove the no-longer necessary checks for range since there's
> no multiplication involved.
> 
> Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-7-a43967e36c88@linux.microsoft.com
> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
> Acked-by: Ilya Dryomov <idryomov@gmail.com>

Hi Andrew,

Please drop this patch as requested here: https://lore.kernel.org/all/d5035d88-f714-47c2-ace6-8bd609d84633@linux.microsoft.com/

Also, the scsi: lpfc patch was also queued by Martin: https://web.git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?id=a131f20804d6

<snip>

Thanks,
Easwar
