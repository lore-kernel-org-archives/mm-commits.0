Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBFE35BDBC
	for <mm-commits@vger.kernel.org>; Fri,  9 Jan 2026 14:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767968959; cv=none; b=teOIZLvrelg+W/QbRNz+kH8S/nipU0woES2dZqApkuoxbLMjgq4407jOzFqeVlqMHwEpjzvl5joJm+PzfjQB6YXpL/TVQ8Wd4XxkjXEALOGRMueAHPB17xhELFFkuH31JMPIcEgsMj816SAQkoM2mEBo6K5TVaJiUIE8eIPoDHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767968959; c=relaxed/simple;
	bh=ldBk9CsOLUeBKQBRdPhgl9YhCPCRauNyfRU8tGCcBYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RzTr01qR1Fripfez7qhnHlHXp2P+JkUGaKr1W4hDh2aYRMZD9O7c0kn2mt2wVMKqoTlrOiOaLu27IMnL8fQt/RL0pje/PBoe6axDp4ZXaioG507Cy942RW8z6KyLFwAy/Qq6LrjpdeKIfPaf+DF+PlENn0AGtPpaWeNgqOrR4tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsfFMmm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsfFMmm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFE4C4CEF1;
	Fri,  9 Jan 2026 14:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767968958;
	bh=ldBk9CsOLUeBKQBRdPhgl9YhCPCRauNyfRU8tGCcBYY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UsfFMmm1GZdoOZAeAlhLoA3PbK0X57qmj0JyFEV4qbrPqjtm9jsSP0HOJ1FrTqLjJ
	 S65I7Stpp4Hrw7epqDcJ9cNNtEnaiD1TrNZB3BPuPKT1XlRXBteDdS4yV338Cod0GT
	 Hz13JcTns+6E18S8QpfJnv3Q4YNhZaJtTgPjTt6ukVX9IZd2sp3pe5DvzgxyanHP1O
	 cKAuPZ3eBFKaET+5AThv278JfIZcDhOhABD7jPvSIerSxo2o8lGeKUak7DDSOROUal
	 CuLXFzL6M4P+fbPhz8kgq+JB1XaABiqTXnd/xxuMtgZNL66t+/SpyTfGU3ZtZXocUA
	 YzQM5qEGo0AQg==
Message-ID: <db6c90de-f14b-4047-b03a-3074ffac1662@kernel.org>
Date: Fri, 9 Jan 2026 15:29:11 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new branch
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 zhengqi.arch@bytedance.com, yuanchu@google.com, weixugc@google.com,
 tballasi@linux.microsoft.com, shakeel.butt@linux.dev,
 roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com, hannes@cmpxchg.org,
 david@fromorbit.com, axelrasmussen@google.com, rostedt@goodmis.org
References: <20260106033842.559EBC116D0@smtp.kernel.org>
 <3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
 <20260106124930.827da463ea281bb392a9843d@linux-foundation.org>
 <4cccaf21-c78e-4017-bb95-29a401d7c3a5@lucifer.local>
 <f916c970-33fe-4147-9daf-159ba61a0302@kernel.org>
 <8b54e314-be57-4fa0-bb53-e9a0adb7d969@lucifer.local>
 <c8b4e2db-def0-49bf-bf04-5dee7e73711d@kernel.org>
 <573a3645-e98f-46de-bb94-ba20daadfaed@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <573a3645-e98f-46de-bb94-ba20daadfaed@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/26 15:17, Lorenzo Stoakes wrote:
> On Fri, Jan 09, 2026 at 02:59:38PM +0100, David Hildenbrand (Red Hat) wrote:
>>
>> Nothing to add to the above :)
>>
>>>>
>>>> Hm.
>>>>
>>>> [1] we have 0day now running and reporting problems mostly private to me, I
>>>> just didn't have the time yet to closely look into the results I've been
>>>> getting because there seem to be some false positive test failures in some
>>>> unrelated tests.
>>>
>>> I've not seen bot reports from mm-new at all, so this is news to me.
>>
>> So far the reports only go to me while we are experimenting with how helpful
>> it is and how stable the results are.
>>
>> I skimmed over some results today, and apparently it found that the new
>> memory-failure selftests are a bit shaky (fail in some environments).
> 
> I guess this is why Andrew isn't bothered about me no longer checking the
> branch then, you're taking over that role somewhat :)

I consider it just another attempt to catch more issues earlier, before 
patches reach mm-unstable and end up in -next.

The build-bots + tests can only catch some stuff. For example, 0day 
runtime-testing is x86 only and only tests some basic stuff (and 
apparently some unstable tests in their ...).

So I don't consider it any replacement for manual testing like you do.

> 
> Did you not have the bot running for this patch? Or did it happen to not
> generate a config with !CONFIG_MEMCG?

0day keeps reporting some issues against mm-new, but given I am on PTO I 
did not get to check all of them yet.

Skimming over the reports, it found one issue reported on January 06:

https://lkml.kernel.org/r/202601070517.0yxdw4WK-lkp@intel.com

At least I think that's the same thing from a quick look.

> 
> I mean I ask again (>/dev/null) - why are we not putting patches into
> mm-new randomly this cycle (I mean also previous cycles but on fewer
> occasions)?
> 
> Surely even if something hasn't had review yet we want to test it no?
> 
> And with no information on the process for moving to mm-unstable, I guess
> we are relying on some privately sent reports being flagged and you taking
> the time to ping people.
> 
> This all seems pretty broken, and you're busy enough as it is.
> 
> To be constructive, FWIW, here's what I propose:
> 
> 	I think we should rename mm-new to mm-early-testing, base stuff on
> 	mm-unstable, and have a clear indication as to how things flow
> 	through.
> 
> 	We should then use the testing to determine stability, drop
> 	anything that's broken, and move stuff to mm-unstable after a
> 	certain _set_ time period where we'd expect bots to pick up any
> 	issue.
> 
> 	Then stuff in mm-unstable goes to Linus if it has a sub-maintainer
> 	tag on it, if not it doesn't.
> 
> As of this cycle - mm-new is totally worthless - and if we don't move to
> something sensible like the above we should just drop it.
> 
> Nobody outside of a handful of people in mm even know it's a thing, aside
> from those I encouraged to use it prior to this cycle.
> 
> Overall I'm very uncomfortable with the way these processes are pushing
> work down onto people with no regard as to the volume of the work or the
> stress it induces with seemingly no say in how the processes are done.

Again, nothing to add from my side :(

> 
> Which is why I'm personally opting out of reporting mm-new issues and
> significantly reducing my review work until there is some movement towards
> sane processes that reflect the needs of the community and importantly -
> those who do the review.

Shame :( But I'm afraid there is nothing I can do and I can perfectly 
understand your position.

-- 
Cheers

David
