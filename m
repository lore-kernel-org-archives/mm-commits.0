Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C533793B1;
	Wed, 21 Jan 2026 10:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768990019; cv=none; b=gjsLuRNsHRhU+eh1x/JGfpQuQWFhWuxpGhQ2hfcWDIIZ4+uxf71Z7i1H+n/34z34d37wpCYH1vV4GhX5RG3gTwRddd89Yao4ewS1UkonVtowKum9i7DSPl4VrVeHcHLVZHU8YCZ8Gna/iQb6Heb6O+EcGZxwULj0TAgFzeUbimc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768990019; c=relaxed/simple;
	bh=Y3Xnh8IHQll1vIPX9JZT1N6XFXrjN3/oUfoUJ2R/Wms=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=deCKKz3M7NY+FPAs0Y7CBSH1OC+u/y9H5eVv/KcilK1OO5B6H5A8TGt0sDX+lxGbeJMEx/bus4o+Tmfbafpa4hQ8WW/0yQADa9KExSaOxkt724GjWL5JUeddWH+GWrJBxKwtnMRFi28n5DKKi1gj8xNSlj++sjVVTDW+hinw1Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlmVHIUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlmVHIUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AE9C116D0;
	Wed, 21 Jan 2026 10:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768990018;
	bh=Y3Xnh8IHQll1vIPX9JZT1N6XFXrjN3/oUfoUJ2R/Wms=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WlmVHIUhzZmqNUem6lxGt5HS/vxCpXGhW9/eZR1YnBJ/2DXEvBX0ghI5xwj9SGubB
	 rSXSSjh6l1zgUBZaWMbT1Kj5gmDVjgOLz6BDDNPF1YEe7DggYi7Py+UQ8PaxZlqPfz
	 nxE5W5IV3Gp/B1CsCSxqId8uS3azGlPhegFyniT6CB25Puxqo3y0Cq/CerYUv280FB
	 oLjFASARGAu2fcRx4lbI7UH0YlWBxABYIh3mhC8O/usdzbCrm5qybJS4aTFfs0Ssjd
	 +teR8Hmj3mYr8ylX5CnrLQDCzR5ATlbQqN41foXTYiNp/WjEgGf9qygogFkcMjKys7
	 pWuLCyIoQqtpQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  mm-commits@vger.kernel.org,
  surenb@google.com,  stable@vger.kernel.org,  rppt@kernel.org,
  pasha.tatashin@soleen.com,  graf@amazon.com,  ran.xiaokai@zte.com.cn
Subject: Re: [merged mm-hotfixes-stable]
 kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch
 removed from -mm tree
In-Reply-To: <20260120093639.3d316ff26f802b36bfe7a285@linux-foundation.org>
	(Andrew Morton's message of "Tue, 20 Jan 2026 09:36:39 -0800")
References: <20260119203054.70AE8C116C6@smtp.kernel.org>
	<2vxzqzrke295.fsf@kernel.org>
	<20260120093639.3d316ff26f802b36bfe7a285@linux-foundation.org>
Date: Wed, 21 Jan 2026 10:06:55 +0000
Message-ID: <2vxzy0lrb7pc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Jan 20 2026, Andrew Morton wrote:

> On Tue, 20 Jan 2026 15:24:06 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:
>
>> > The quilt patch titled
>> >      Subject: kho: init alloc tags when restoring pages from reserved memory
>> > has been removed from the -mm tree.  Its filename was
>> >      kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch
>> >
>> > This patch was dropped because it was merged into the mm-hotfixes-stable branch
>> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> 
>> This patch isn't quite complete. See [0]. It doesn't do anything wrong,
>> it just doesn't fix the problem for every case.
>> 
>> I suggested a re-roll of this patch based on top of my cleanup patches
>> [1], since I think with those the end result is a bit nicer.
>> 
>> I suppose we have 3 options:
>> 
>> 1. Take this patch in hotfixes and leave kho_restore_pages() path
>>    unfixed. The fix the rest next merge window.
>> 
>> 2. Do a new version of this patch fixing kho_restore_pages() with the
>>    current code, and then re-roll the clean up series to fix conflicts
>>    for next merge window.
>> 
>> 3. Pull in the cleanups in hotfixes too, and then do a new revision of
>>    this patch on top.
>> 
>> I don't think the end result of option 2 is too horrible, so I think
>> that is probably the best option, but do let me know what you'd prefer.
>
> No probs, I removed this patch from mm-hotfixes-stable and put it back
> into mm-hotfixes-unstable, with a note that an updated version is expected.

Thanks.

Ran, would you be able to send a fixup soon? We are at -rc6 and it would
be great if this can land in 6.19. If not, then I can take it up.

-- 
Regards,
Pratyush Yadav
