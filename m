Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8791817548
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 05:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749102801; cv=none; b=NPNQeaTWAGp5HZhA9kWDCOJC4SQ/xk1lKz4sU72RFY/AyFO57OXWN4hvrlkKNelT9n9N1UkoEU3eWQQcsyxh8sDgJ8qqw0Cn5bLoSGrR22HKGbzVlUl5YVpuWjbNWVv5cTOWnClzorBn5Yd0hnq6iY264csUJ4+ou4/O9ykA++U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749102801; c=relaxed/simple;
	bh=hQh5XMzft1dx2UZFC/71I/Er+LMjDduX/8TebfXxyQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=l/zXG8kEG3b+f9Zr7QrNO2OnLBQhAFQtf0lCR01X7SIQvacAfnBjGejESZOBbXxkYnRIpCqiatsou4zYuJHrtlzSjHy6BQsq6ilWLwNaDUwdoU1euPMqaZG5SwxNdTMsyZW+1IU1x1VN+9xSPi2GDG5IROlg7DKoX6TuaQ1bqBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CgTpi8U3; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CgTpi8U3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1749102788; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=k0b3fdop58DOXW0poL+eB5SrG70cx3/HLRUL9gmYwo0=;
	b=CgTpi8U3zpwJdlXqA/fnRRVtJ5cb8EyU+O4Jc3PKRzmCVvhgkV7MOR3puKQvSr3GDMiNAeoLmfBmbxJHRmNsaarI3MAlAv048Islxzi353skj8m6LmEhdC6fIhd46uA3GEyxU+e30Kq2rWiMIU0XSi1Z3l8saPjXPkjmkIgqolo=
Received: from 30.32.86.63(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wd6tE5v_1749102787 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Jun 2025 13:53:08 +0800
Message-ID: <3915755a-e686-4a11-a03e-f62170301179@linux.alibaba.com>
Date: Thu, 5 Jun 2025 13:53:06 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch added
 to mm-new branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 Nico Pache <npache@redhat.com>
References: <20250604222256.CB0B4C4CEE4@smtp.kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250604222256.CB0B4C4CEE4@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew,

On 2025/6/5 06:22, Andrew Morton wrote:
> The patch titled
>       Subject: mm: khugepaged: allow khugepaged to check all anonymous mTHP orders
> has been added to the -mm mm-new branch.  Its filename is
>       mm-khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch
> 
> This patch will later appear in the mm-new branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
> Subject: mm: khugepaged: allow khugepaged to check all anonymous mTHP orders
> Date: Wed, 28 May 2025 20:31:46 +0800
> 
> We have now allowed mTHP collapse, but thp_vma_allowable_order() still
> only checks if the PMD-sized mTHP is allowed to collapse.  This prevents
> scanning and collapsing of 64K mTHP when only 64K mTHP is enabled.  Thus,
> we should modify the checks to allow all large orders of anonymous mTHP.

Sorry for troubles. Please drop these 2 patches (which are used to fix 
the mTHP collapse issues based on Nico's series[1]) from the mm-new 
branch. As I talked with Nico, he will rebase his seires and take these 
2 patches into his new version. Thanks.

[1] 
https://lore.kernel.org/all/ac9ed6d71b439611f9c94b3506a8ce975d4636e9.1748435162.git.baolin.wang@linux.alibaba.com/T/#m9d169daf172d32f94ee5d10e1458868975d7afec
