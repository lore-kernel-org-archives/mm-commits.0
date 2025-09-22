Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61DF7464
	for <mm-commits@vger.kernel.org>; Mon, 22 Sep 2025 21:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.30.212.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758577684; cv=none; b=fdhUb3x75f0orBqXVIIGmA8+XHaBqcRjbSi7Y/kpU7FO2Pswc6VRNqmWxrJBRLKXDniaVwYl/BnjbstxnvCquG5PRKzJRG49G8mSs+f/tB7D6KuT6rFKCDV+0iFwN7RNkeYzQH1jXVuBbzTXBy/mz7w4aEaa8BYyS1vHzqig8Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758577684; c=relaxed/simple;
	bh=5i35AruKCLV4zpaeZj+8McdipeRi5Ds1OzlrMCI2T04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gNvv7ElCTTlsPaH9CSVqmC5I9ZorYi6E4wwCfklzUJdBprlY4lLSJyL1uwP3Zav8KG7n29HNb6mQX/9Is705SdUoPm9WdZ6dTE4njCh0d9/F1x466mh860/jq1Pz7xkBieXG0Oq66a1BU9GmWoPZAYRvQcjcYXcHl7nxLK8GCAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=konsulko.se; spf=none smtp.mailfrom=konsulko.se; dkim=pass (2048-bit key) header.d=konsulko.se header.i=@konsulko.se header.b=gGFERfZ7; dkim=permerror (0-bit key) header.d=konsulko.se header.i=@konsulko.se header.b=8YzRh9X8; arc=none smtp.client-ip=46.30.212.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=konsulko.se
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=konsulko.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=konsulko.se header.i=@konsulko.se header.b="gGFERfZ7";
	dkim=permerror (0-bit key) header.d=konsulko.se header.i=@konsulko.se header.b="8YzRh9X8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758577677; x=1759182477;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=qDf64VNhD7VGX3hHaREYDBF2GGM7OYKXcYvJHKrKW8o=;
	b=gGFERfZ7V3OI87iit5xXFnniSaIcTviDA9g52kIaNwhaf4LoaDxzteRQkS60oTvmm9y5KReRReKdW
	 4FZnotLQnKzxt6a3/RPTdyQIXBzRxuqb7veNhmq17Slt7mcaAQw4h3VVOKhrKiQ2H35IE/xhzOz67i
	 flS+gItjCznlgD/Oh4Z4PaW6vB2ysD/5uanPYME1arwgldAntnRbGfxydcBdZzKnTV16HgSOeowJR7
	 8XA1ZRWYNp8GiaOT+MgObo78B5e0oCegOTQUbc7ZlMkTqQ84jzc2XsC5Hlt6JsNw9PVSm5IgAsBW7s
	 X1Ks0Fa0g46yTcivIlHYhtOLVCvkwJA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1758577677; x=1759182477;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=qDf64VNhD7VGX3hHaREYDBF2GGM7OYKXcYvJHKrKW8o=;
	b=8YzRh9X8ZBnMaU0b4IyOKDDlj3Pqi18ewmfXQy0pmVR7duI2mdq+fd8nKaiWAnSFxHozQWoSbgC4r
	 AyD+E2IBA==
X-HalOne-ID: cb62e40e-97fd-11f0-99c9-e90f2b8e16ca
Received: from [192.168.10.245] (host-95-203-13-255.mobileonline.telia.com [95.203.13.255])
	by mailrelay2.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id cb62e40e-97fd-11f0-99c9-e90f2b8e16ca;
	Mon, 22 Sep 2025 21:47:56 +0000 (UTC)
Message-ID: <2d34fe0d-2dbe-4593-beb4-69832962cb8a@konsulko.se>
Date: Mon, 22 Sep 2025 23:47:54 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [merged mm-stable] mm-remove-unused-zpool-layer.patch removed
 from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhouchengming@bytedance.com,
 yosry.ahmed@linux.dev, sj@kernel.org, nphamcs@gmail.com, hannes@cmpxchg.org
References: <20250921212316.D4DD5C4CEE7@smtp.kernel.org>
 <9ff74ee5-57df-4bdb-9da3-1644d8a083db@konsulko.se>
 <20250922143832.f9df607b4315b9cb10bf3d36@linux-foundation.org>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <20250922143832.f9df607b4315b9cb10bf3d36@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/25 23:38, Andrew Morton wrote:
> On Mon, 22 Sep 2025 12:11:21 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:
> 
>> On 9/21/25 23:23, Andrew Morton wrote:
>>> The quilt patch titled
>>>        Subject: mm: remove unused zpool layer
>>> has been removed from the -mm tree.  Its filename was
>>>        mm-remove-unused-zpool-layer.patch
>>>
>>> This patch was dropped because it was merged into the mm-stable branch
>>> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> With this change we will no longer be able to compile zsmalloc as a
>> module if zswap is enabled.
> 
> 10k of .text.  Is that a big issue?

No, but the zpool api was way less than that and then it was an issue :)

>>
>> ...
>>
>> Are the
>> maintainers prepared to fix possible build breakages and
>> misconfigurations on some Linux distros as we move forward with this?
> 
> I hope so!

