Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C789214269
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 01:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716944508; cv=none; b=IF1egKd5TKHCooYM/190fQnRRxrqaZ5NADVbXGfWQOmxtBNyUq8r2iAq7z4c5OSdobL4g+f+wELIHZJmWxENsQ6dXp/mf03zqAAsZgYGG/K4FH8pa8dQXLf/VBMMxpP/slAsvKd44hQKPJ3zHiYtVjC0BU282juEguJsses0Bx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716944508; c=relaxed/simple;
	bh=lG79sPp1n17zFWw5Zzrezm25bER8ubj0t4DWqGVTPes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mnPY8Hnuj/6f5iblSFGxeWI/io2GVDs0ZQZFU2Yn6zsv/PK09ilN7dqFNJOtmC+GJowDfb5Xc5mNJEA9ceLxDcILDZU1sgOuehjG+NvaKw34tr59gW1P6Njlf0hyGIFJK5DZ3w3Qqi9jDj/aLykyY392feFgEEXZhuYvuOMC16A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=QqgeaOlw; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="QqgeaOlw"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716944503; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=idkhyrC65M2XNwfZQ32fKPB3oa3Q5Nclk5BWSitAo64=;
	b=QqgeaOlwozEqueDxsub2gVA0InyDCoa3fWhX0ylIUP1rrHIFXWl7aATFT8N+wTlaD5x9X/a/GH413lXRNsUBRnK3Tuh+3Dzcfbd8BSwsx4gEHrw8diPruZW6QZslDHz0vlby9xHEg37oJ/x0m6PQeI4zMMxkc846zVw/u4OJV9s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067109;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0W7QrkQR_1716944502;
Received: from 30.97.56.64(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0W7QrkQR_1716944502)
          by smtp.aliyun-inc.com;
          Wed, 29 May 2024 09:01:43 +0800
Message-ID: <77f4ca19-f0f2-4882-813a-2fec9ba5ec1f@linux.alibaba.com>
Date: Wed, 29 May 2024 09:01:42 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch added
 to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org
References: <20240523194021.CF145C2BD10@smtp.kernel.org>
 <CAGsJ_4z_FiDM8v8h8gbfmr5ooU8Dw6TyQrG3MXRUdOzQfmrjhg@mail.gmail.com>
 <20240523165005.3b1569628569060cfba211f4@linux-foundation.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20240523165005.3b1569628569060cfba211f4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Andrew,

On 2024/5/24 07:50, Andrew Morton wrote:
> On Fri, 24 May 2024 10:55:17 +1200 Barry Song <baohua@kernel.org> wrote:
> 
>> On Fri, May 24, 2024 at 7:40 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>>
>>> The patch titled
>>>       Subject: mm: drop the 'anon_' prefix for swap-out mTHP counters
>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>       mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch
>>
>> Hi Andrew,
>>
>> Baolin is aiming to implement this rename for version 6.10.
> 
> No probs, I kinda missed that in the changelog.
> 
> Things like this should have a Fixes: so that anyone who backports the
> original feature patch knows to grab this as well.  Please?

I didn't see this patch in today's mm-hotfixes-unstable branch, did you 
miss it?
