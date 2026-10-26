Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793057196;
	b=CK6Hp7SqM/R1Q5xSbIORkr2DPtwr4QJ3vCC4OcILhXmPtrVe/kvNzEzgsq9XuCI2rLkY
	 dIQN8V5XU2GKvlsPVToOEQqtGqgcfk+lleCLL3f5/89pidy5ahu/6xhODuh+fqz7smrya
	 Go80qnZ2vmsJTR4MF8VKBGppJeRdsd5S80ossZ6h0mJyb8FNr37C3X7OSNLTR/LgHUe8i
	 48GXhykToaZGcLlMykmqQji8N07I0JN3fyUtyyNWYIgKZOqW46Hwzk+0VLGUu7DBujUd+
	 SGOWA7acNsNch39K1fycLlstBcgOLgSVrkpivJ13qvVobNqVLbZeZM15hdGtJxkfZSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793057196;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:From:To:References:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=cGqMlMVla5/cz3DOLEBjj0wDB6elRMzLIYmWsqwedfY=;
	b=UUSQZ50s7KZPq8J/KCW1v+YxEh5xnVsN9vai2Lr4bLzsbXVvVg5dmyFsSQLcfp2fX8F2
	 NjUWwLE9u8EgrxwwuzZGZkpLrPlkaCAf8WtwtwINBa3CtBqqv65cEo+W6UgW1QONviG3n
	 TMST5qayFBx5SrEgEayGWntWpTs3zxxvwI4lgVOjn/aeRJjbfI+EVOYbrQl+JGu4OtEWe
	 CxEiyfycj5nO5M95BfNsqv/3Axd/v796mjWPuH+wHDYGMfaBFisoTTNtyvlcnS6ateeLY
	 q/H5SrkWjRK6XRT2a/M/IcNDpBpeeR4TF90pjNmYgOn3C9XBsUr9tk/PyvSE1EWgWlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lLgpXxfH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7C4606A31A
	for <mm-commits@vger.kernel.org>; Mon, 26 Oct 2026 23:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lLgpXxfH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C391F01829;
	Mon, 26 Oct 2026 23:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057196;
	bh=cGqMlMVla5/cz3DOLEBjj0wDB6elRMzLIYmWsqwedfY=;
	h=Date:Subject:From:To:References:In-Reply-To;
	b=lLgpXxfHisuC2SWqEgdEPsH4TKovLBcX0HXnLa6JaGUFv0ga0lfeZ3srNGraoqb5A
	 xFXT21ZTzT9XjlAIdydQCh6wKZoygTn0Z28VQRppLentkFWCXJXO/x2SyES1KeTQ3B
	 rL3KSj261+Cybmcl2MpgcXvc2kS2npJq/qHCUD/o9W0whQvnKbhSJ9JWFWJIgVuiIs
	 PbPrrOiG6W7P4QePY8eiBkflWhxt6ooHVrwURs4oj+5CXH8by4EquUAhtxhfovfaG/
	 fpMyys3jP7gDzfo6K2m2bTMBwXLtQLOJneiPxerhee9TD9kXUigQrGSTSiwaGUhD+4
	 0EWBuNBGb+hig==
Message-ID: <47838157-139f-4863-8524-147102194c6c@kernel.org>
Date: Tue, 27 Oct 2026 00:26:27 +0100
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [merged mm-stable]
 mm-truncate-fix-data-loss-when-splitting-straddling-large-folios-fails.patch
 removed from -mm tree
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ziy@nvidia.com, yukuai@fnnas.com, yizhang089@gmail.com,
 yangerkun@huawei.com, willy@infradead.org, wangkefeng.wang@huawei.com,
 vbabka@kernel.org, surenb@google.com, rppt@kernel.org, mhocko@suse.com,
 ljs@kernel.org, liam@infradead.org, joannelkoong@gmail.com, jack@suse.cz,
 hughd@google.com, djwong@kernel.org, chengzhihao1@huawei.com,
 bfoster@redhat.com, baolin.wang@linux.alibaba.com, yi.zhang@huawei.com
References: <20261024085807.3E8AA1F01825@smtp.kernel.org>
 <64c9b5df-7164-4f08-a0ef-cc2c7bcea26a@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <64c9b5df-7164-4f08-a0ef-cc2c7bcea26a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/26/26 23:52, David Hildenbrand (Arm) wrote:
> On 10/24/26 10:58, Andrew Morton wrote:
>> The quilt patch titled
>>      Subject: mm/truncate: fix data loss when splitting straddling large folios fails
>> has been removed from the -mm tree.  Its filename was
>>      mm-truncate-fix-data-loss-when-splitting-straddling-large-folios-fails.patch
>>
>> This patch was dropped because it was merged into the mm-stable branch
>> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
> 
> Andrew, can we hold off sending these for a couple more days.
> 
> It's unclear how they related to the other shmem fixes I sent which fix stuff
> older than that.
> 
> (Zi just mentioned that it might become a mess)
> 

Ah, nevermind. We'll figure it out.

It's all a mess already. An utter mess.

-- 
Cheers,

David
