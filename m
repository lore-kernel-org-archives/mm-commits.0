Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2608F15A85A;
	Mon,  8 Dec 2025 01:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765156307; cv=none; b=SWtHnCqUQ6hb88YuPSnE1UX8xyfLox49w8KbzVY6x/xw+xHJYhtGBNgxsxqeqC+cXSPtOPHOq2wDKhLwuIH7mWPcMlNYkCHDZw75mZtTPbjAbkBZzyAvuFqF77c0rK8h8yLETrqW0EP91z8EQvKkdOzfQHWMMgvSrOwtX3EQn1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765156307; c=relaxed/simple;
	bh=CwkFlzNPxLg8v7gy9rlKCeLwbavgiyjgtlOMH1k7on4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a5fW4oR7IvpR5PoUaK2JFXH7q3tXWKneRUs8IMsygU+N9aFDem76LC+wxvwj/pkWG+97mty1HyD9wUqRTSr3wQI/4gdPygGZKQwHAH08qOxYWHjMnzQotfm15wct86gzkChpZq0QgkxK1rtGHge9E2Unt/pZyss18iPPyBJIxhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=m4b1SK1W; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="m4b1SK1W"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765156295; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6rVqmSkxnEapCQZcc1eYuT2scz6BrFpy/qXEqATvDEE=;
	b=m4b1SK1WZYL7feucXMWsVwY8xRiOoBDdEC9MZ70YptgGH0IMaHsqRUg7eg0ce6T3lecOFc0gJMVMUlGLLywUwmGh0nw4dGhB6C6oj6XTaIfQBF3xnk+9AiadQNu4f5r22aE0Nl13+e5NVC9BLqWf9VCXLxIYV9yK1O9vbk2LQkE=
Received: from 30.221.145.74(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WuElbFK_1765156294 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Dec 2025 09:11:35 +0800
Message-ID: <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com>
Date: Mon, 8 Dec 2025 09:11:34 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Linus Torvalds <torvalds@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dmitry Antipov <dmantipov@yandex.ru>, Heming Zhao <heming.zhao@suse.com>,
 Mark Fasheh <mark@fasheh.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/12/7 07:40, Linus Torvalds wrote:
> On Sat, 6 Dec 2025 at 11:15, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> Dmitry Antipov (8):
>>       ocfs2: annotate flexible array members with __counted_by_le()
> 
> This causes the build to fail for me with gcc 15.2.1:
> 
>   In function ‘fortify_memset_chk’,
>       inlined from ‘ocfs2_reflink_xattr_header’ at fs/ocfs2/xattr.c:6365:5:
>   include/linux/fortify-string.h:480:25: error: call to
> ‘__write_overflow_field’ declared with attribute warning: detected
> write beyond size of field (1st parameter); maybe use struct_group()?
> [-Werror=attribute-warning]
> 
> And the reason appears to likely be a bug this exposes, rather than a
> bug in the annotation. But I really don't know the ocfs2 code at all,
> so I'm going by "the error message is horrendous, but I can follow the
> logic in the code, and I think the code was actually wrong".
> 
> I have "fixed" things.
> 
> And I put that "fixed' in quotes, because my fix looks sane to me, and
> makes the array counting logic happy, and my fix may well be the
> RightThing(tm), but somebody who actually knows the ocfs2 code needs
> to check it out.
> 
> See commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by
> error") which simply makes the 'last' pointer point to the actual last
> entry, rather than point to one _past_ the last entry.  So now the
> memmove() and memset() in the "possibly remove entry" loop below might
> actually work right, in addition to building cleanly.
> 
> But again: I did this without knowing anything about the code, just by
> looking at the logic.
> 
> I _think_ the code used to copy one entry too much, and cleared an
> entry past the end. It probably worked fine, because the code also
> decrements xh_count, so even if it cleared the wrong entry, it was
> past the counted end.
> 
> I'm a bit unhappy that this didn't show up in linux-next and that I
> had to chase this down. I don't think my gcc version is that odd.
> 
> Anyway, it's building for me, but I really really want some ocfs2
> person to take a look. Please?
> 

It looks fine to me.
Sorry for the noise and thank you for pointing out my mistake.

Thanks,
Joseph

