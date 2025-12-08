Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AB317BA6;
	Mon,  8 Dec 2025 04:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765166476; cv=none; b=S5zbavi0pSqRPVYw92q8FyP4xQfFrx5RLIzSE1bVxMLWgk4pdFvwOv7IirBKwtE8H9MoMn+bm/t96EZMGCYAS7B2jwNRidl1H1Z7cCOYlmQ1aEEOcijm7itXUjNklDovVmgTPNM8P9R1VRTXd3T7+GyRDO9sTQE2y5B1eIF7mvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765166476; c=relaxed/simple;
	bh=nmo7oqDIW0KOzGpp1K1/CJCVdIT1XxynZs83KvQ/Vo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dj4ZHh5bfJ7KO9/gKcwSX3ClwJvcinD4gmOnAVbN60MfQgWKzWXLUF9n5N7WDyzHLpKNZIxNG3r1x08/02As2TrYAPcrYMBmIYRpJDg584ChbaRdijDf9uZhAe2iMorJT14mju157n22X6CL0m2qOoOtqtswUI5aiK+i5scS4EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bKzcjPjP; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bKzcjPjP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765166471; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=p/1ob/kLkc71l/BDdSnNsSLL33QQ6a4e2+EPIygILiM=;
	b=bKzcjPjPLHd08oEgF5RD04ligoxr5xIzBJvdgqZxBMg+V884XuFAExlusK0EN3P4gLqVUoOdDVM3e3nw0N/0XRlw/P4X6bx51FIajttnfYWi8/n+KuiLYL3ulf5XcLdIzuctvUo7+LVVOPT1Uo2KnncDPWJ+/NeErAWnAwd9ss4=
Received: from 30.221.145.74(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WuFMMVn_1765166469 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Dec 2025 12:01:10 +0800
Message-ID: <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com>
Date: Mon, 8 Dec 2025 12:01:09 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Linus Torvalds <torvalds@linuxfoundation.org>,
 Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
 <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com>
 <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/8 10:21, Linus Torvalds wrote:
> On Mon, 8 Dec 2025 at 10:11, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>>
>> On 2025/12/7 07:40, Linus Torvalds wrote:
>>>
>>> See commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by
>>> error") which simply makes the 'last' pointer point to the actual last
>>> entry, rather than point to one _past_ the last entry.
>>
>> It looks fine to me.
>> Sorry for the noise and thank you for pointing out my mistake.
> 
> Note that if my fix is correct, the mistake is most certainly not
> yours and goes all the way back to 2009, and commit 0fe9b66c65f3
> ("ocfs2: Add preserve to reflink").
> 
> But I would really love to have somebody who knows that code go
> through it, and see if my fix actually is the right thing to do.
> 

Go through the code logic again, maybe I'm wrong before.

Take the following flow for example:

ocfs2_reflink_xattr_in_block
  ocfs2_create_empty_xattr_block
    ocfs2_create_xattr_block
      memset(xblk, 0, inode->i_sb->s_blocksize);
  ocfs2_reflink_xattr_block
    ocfs2_reflink_xattr_header

It seems now new_xh->xh_count is 0. That's means, it is trying to add a
new entry and here 'last' is pointing the next free entry.
If so, the original code seems right.

Heming, could you please verify this? I'm not familiar with this logic...

Thanks,
Joseph
