Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A89D531077B
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 10:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755511763; cv=none; b=RpRbqZcFgtGhcBOcs9eDV0Mxofpk34Juxd5QcRtIjVjXMMmzdupaaU41r6e41ZxjawHKXGlpXPp0ikuT29EeTBZtwJXNpJVNIEGfYSozTbWRuHov+CmjYCbv51N4DvoIHISXWLGmRHPOt3vLzEUUPu4Aq1Qr7AOUQ9qJha64v/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755511763; c=relaxed/simple;
	bh=dRjUokElFpizXmf+MDjZHCnu15wZgCrFoRROOkRLwq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EVzJPfFFY8rRi19JzxzTY0u7APtBc8lSoeL3ERczE0Vvg66FJVqz5kHzNP1VqEtYPnX6TXxqNRt9XadnEX1DPgGAXHttssMMhw9+UQ+lPWSYyJaoHF6CSRsyetSJDu67NHGaNnZ/n9McEHuvDocJC6as12OnCFpZQD+G1XmWYyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=fFayugq+; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="fFayugq+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=m2l46WJO4VK+1JiuAG50AI5HKu1nyhZpOpXkBMXDepQ=;
	b=fFayugq+R8dWitkIBvaKBEp6AOfOwegDmsecEegzqrgJZy0luJYcLGGo0YIIgg
	Zg913lWgtzympjzF3wFd/k6sou9t0bLSgCjIK/UTcB6F0nuDzPTwzIQfxCoLeoWd
	OEAGCKvvQaQyK8IGn899xbdX7mA7xt0iRnwbF8GJ7IfV0=
Received: from [10.42.20.201] (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDnZvS3+6Jot53UCg--.18052S2;
	Mon, 18 Aug 2025 18:08:55 +0800 (CST)
Message-ID: <b9c15797-971c-4347-b4ac-3c889a2bc820@163.com>
Date: Mon, 18 Aug 2025 18:08:55 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mpage-convert-do_mpage_readpage-to-return-int-type.patch added
 to mm-new branch
To: Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, Yuezhang.Mo@sony.com,
 viro@zeniv.linux.org.uk, sj1557.seo@samsung.com, linkinjeon@kernel.org,
 jack@suse.cz, brauner@kernel.org, chizhiling@kylinos.cn
References: <20250818024604.7A133C4CEEB@smtp.kernel.org>
 <aKKZCBHCNQYxWKXX@casper.infradead.org>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <aKKZCBHCNQYxWKXX@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wDnZvS3+6Jot53UCg--.18052S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrGr4rAw4kGFyfJr1fuFW7urg_yoWxArb_Wr
	W2vanxC3Z2gry5Z3WDuay7JrZFya95W34UZ34qqFnru345CrZxXF9Fvrna9FW8AF1Skrs0
	9rs5WFW29wnY9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUsa9DUUUUU==
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiFB+tnWii9oN8MwABsK

On 2025/8/18 11:07, Matthew Wilcox wrote:
> On Sun, Aug 17, 2025 at 07:46:03PM -0700, Andrew Morton wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>> Subject: mpage: convert do_mpage_readpage() to return int type
>> Date: Tue, 12 Aug 2025 15:22:25 +0800
>>
>> The return value of do_mpage_readpage() is arg->bio, which is already set
>> in the arg structure.  Returning it again is redundant.
>>
>> This patch changes the return type to int and always returns 0 since the
>> caller does not care about the return value.
> 
> This makes no sense.  If the caller doesn't care, then it should return
> void.

Okay, I will change that.


Thanks,
Chi Zhiling

