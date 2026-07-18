Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24BC1F5825
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 14:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784384225; cv=none; b=hHKUjoREzC0K2xpwXWvDnUuP7HKBbXrQ/Pe0zQHQ85EfAIgdPcEgaQ7/KcA25tl7pgBBfDRqnMM2JGjuDOYRqL6udmd8QrHFf4x1Rplcr9d3IcR8TrkpaDD0ANmeXh0hplJMDExPK06FddCXYY7SgQD/peJxhXkc+GLB/1yn6Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784384225; c=relaxed/simple;
	bh=T30ICEqG/afunpxhrRe44Ow8E5g9tEyEdOKgZWNAo5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GgaevPYUNYrVIRY2R9QC5zIQ0C5h2YqehiP7EyQh7wzm/nathWC6pdVr4yuudtdfhKnD6rqzx3t2OtIcI7ZU1RheYmRu1wAz0yd22j3NaAsKT02TRwRQvPKqXxhlZr60fDVYbKvwiKOkyXWZpbqy4WPiJm2zqjNjY0KidFu36co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fL8NYDfb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MSpQUHtd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fL8NYDfb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MSpQUHtd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784384221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sNW2Jp4BFDbSVMZMnYLlJejixEfYERSiyCu3BA5HvqM=;
	b=fL8NYDfb3iTSzwZbdICMixr7C20H9O3asbiXwx3WDe7LkkiS3J8TRGp66XnbEVElymXDo1
	16pEwxWZDUnhyjn2Ojefv4YxxRbCIe64E/zwOxooGZ7b0nW5Xb4krC05mYEbIR1zXzq9Kq
	G4liWksiy462a3430DsCwjJXdPsCm6E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-rdBu_0CbNpCf3LhHetMPOQ-1; Sat, 18 Jul 2026 10:17:00 -0400
X-MC-Unique: rdBu_0CbNpCf3LhHetMPOQ-1
X-Mimecast-MFC-AGG-ID: rdBu_0CbNpCf3LhHetMPOQ_1784384219
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-495529a93f9so1606355e9.3
        for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 07:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784384219; x=1784989019; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sNW2Jp4BFDbSVMZMnYLlJejixEfYERSiyCu3BA5HvqM=;
        b=MSpQUHtdtDyNwojcoPVDPRKzqvoxWggCoxxZsK5n6R2IiyVFeHH9gOB2GLXJDSUY8o
         8R5apphL90mO2K8JXbogzf/e9HtLLki7xOA/XCy7kkJAwZwTXNiIXGF1z/qttGHm/KMT
         irTJCkQ0RorMLeDv0OmGj3luN9hktW80HcLMcBDAT8oyfCIXwShfGYovSxkECpwwIJE8
         etRi+pqGhl22tLZl3HJJHcRZ7VtuG3dvYy3JbYIwjcQrlLKcPIkWSIl91B9OereR6+tR
         flY4ERV1nNjOdUuS75I3/XQUoASXRnV9kcNfdA+Cft0I1/zakw2PaBzJc22s0ss0rQlw
         5VLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784384219; x=1784989019;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sNW2Jp4BFDbSVMZMnYLlJejixEfYERSiyCu3BA5HvqM=;
        b=fVOgzqkJmx1MpiLtstIrtUoMf1FvFZx/uVxTeAv0NSToJd9OfKvLu/lV7gJIjvk3yK
         iOtMxBnJllgLDQ5nVfQdz3kvuSZyQTeH6P15PUQWCmmcDsKqaQCN9JFIpXlLYncxss+l
         Lv5cLQMimTHBl7MwUIJ+2mPIFxnyBBJKYV0tzMUhtwcjOAS+PGgH0lnOQ3fhk/aVgA3M
         QkPWPBjV3rNxuT4iJt7WJrtrPjshEt2Y+Cw0V3lRFouVjj+shwMbZOp2/UZVkM2RX8qG
         9ltqjfTJ/x2ivEx3VymQNsqrWxZpZjCTOf5zkkiq1wY1qK3ssi3JS3IlIgy3pbBk6HP0
         lF0A==
X-Gm-Message-State: AOJu0YwFUyS7xyBLaB6v8gmk6r0Y/XijuxHbdqNJQZkV1Hrowl1PhLTF
	7SmZEGdkBNaXs5ttMsVVARTsWRiNdAL8HQke0KG+uxn99lpDlXKSU7EkEJ5n1DCTM1mhG0yHGJF
	3VXyU4GTE9NTGjAZ0zXz9DfamXpaGzz2Oe+SVY6jMVbEF9edFhEpWK3aDZ/CpMg0=
X-Gm-Gg: AfdE7cmLjh6foND3smCKr4Sfb64hmz4N/FBghf6HV+ODe8g7L+fA5ZJMGaU0QJhgSDj
	v8LkdJLjKc763ZV3mKRxVQvMhZ2e6Rb8yUxt+7S7T6hNA3lhwPWBXxs50mTprq5u5c3AbS0tC02
	GtuOvLufErMSMmPApdFA3g5effNtf+u64CuZwNKlIMNW+LQ83UQvaIdz7CBjMQYdG6GqWrmVIyt
	/BkR1kDTv4b4fsmt25O/RxyWzxlRk6n9913S4sbRJSUV78RWknpzB7q8+5TCDuf5HYRNg6LX/bu
	NYVXeKtxpHMncu9k26z/1r/vViqrWqoCXhMpS9IklngQxfxJSDAEAfQLMdw1veyqn8BmcpO7jub
	5xdg7kACTO2aBn0r4oL6XKeuui1AmUSM=
X-Received: by 2002:a05:600c:524c:b0:495:4cb6:71c3 with SMTP id 5b1f17b1804b1-4954cb67f3dmr63627425e9.39.1784384218680;
        Sat, 18 Jul 2026 07:16:58 -0700 (PDT)
X-Received: by 2002:a05:600c:524c:b0:495:4cb6:71c3 with SMTP id 5b1f17b1804b1-4954cb67f3dmr63626945e9.39.1784384218103;
        Sat, 18 Jul 2026 07:16:58 -0700 (PDT)
Received: from redhat.com (bzq-79-177-145-168.red.bezeqint.net. [79.177.145.168])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2b87c6sm212015435e9.7.2026.07.18.07.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 07:16:57 -0700 (PDT)
Date: Sat, 18 Jul 2026 10:16:54 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, xuanzhuo@linux.alibaba.com,
	vbabka@kernel.org, stable@vger.kernel.org, rientjes@google.com,
	jthoughton@google.com, jiaqiyan@google.com, jasowang@redhat.com,
	gthelen@google.com, david@redhat.com, david@kernel.org,
	alexander.duyck@gmail.com, linkl@google.com
Subject: Re: +
 virtio_balloon-avoid-shrinker-execution-during-pm-suspend.patch added to
 mm-new branch
Message-ID: <20260718101506-mutt-send-email-mst@kernel.org>
References: <20260718003902.B6DD51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718003902.B6DD51F000E9@smtp.kernel.org>

On Fri, Jul 17, 2026 at 05:39:02PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: virtio_balloon: avoid shrinker execution during PM suspend
> has been added to the -mm mm-new branch.  Its filename is
>      virtio_balloon-avoid-shrinker-execution-during-pm-suspend.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/virtio_balloon-avoid-shrinker-execution-during-pm-suspend.patch
> 
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
> 
> The mm-new branch of mm.git is not included in linux-next
> 
> If a few days of testing in mm-new is successful, the patch will me moved
> into mm.git's mm-unstable branch, which is included in linux-next
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Link Lin <linkl@google.com>
> Subject: virtio_balloon: avoid shrinker execution during PM suspend
> Date: Fri, 17 Jul 2026 00:22:21 +0000
> 
> During PM freeze (e.g. S4 hibernation), virtballoon_freeze() calls
> remove_common() which resets the virtio device and deletes all virtqueues.
> However, the balloon shrinker remains registered with core MM.
> 
> If memory pressure occurs during S4 hibernation image creation/saving, MM
> invokes virtio_balloon_shrinker_scan(), which attempts to reclaim free
> pages. Although return_free_pages_to_mm() only frees pages back to MM,
> reclaiming free pages under memory pressure can trigger page reporting
> which might access the deleted reporting virtqueue if it is not yet
> frozen, or interact with other parts of the driver in a teardown state.
> 
> Avoid this by adding a `suspended` flag to `struct virtio_balloon`. Set
> this flag to true in virtballoon_freeze() and false in
> virtballoon_restore(). Check this flag in both shrinker callbacks (scan
> and count) and return 0 if the device is suspended, preventing any
> shrinker execution while virtqueues are deleted. Wrap the lockless reads
> in READ_ONCE() and writes in WRITE_ONCE() to prevent compiler
> optimization issues and KCSAN data race warnings.
> 
> Link: https://lore.kernel.org/20260717002311.681748-3-linkl@google.com
> Fixes: 71019de8219b ("virtio_balloon: Add free page hinting support")
> Signed-off-by: Link Lin <linkl@google.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Suggested-by: James Houghton <jthoughton@google.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Alexander Duyck <alexander.duyck@gmail.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Greg Thelen <gthelen@google.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Jiaqi Yan <jiaqiyan@google.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This patch generated quite a bit of discussion. Are you
sure it makes sense to keep it in mm as is?
In particular:


> ---
> 
>  drivers/virtio/virtio_balloon.c |   49 +++++++++++++++++++++++++-----
>  1 file changed, 41 insertions(+), 8 deletions(-)
> 
> --- a/drivers/virtio/virtio_balloon.c~virtio_balloon-avoid-shrinker-execution-during-pm-suspend
> +++ a/drivers/virtio/virtio_balloon.c
> @@ -68,6 +68,8 @@ struct virtio_balloon {
>  	/* Prevent updating balloon when it is being canceled. */
>  	spinlock_t stop_update_lock;
>  	bool stop_update;
> +	/* Prevent shrinker from running while device is suspended. */
> +	bool suspended;
>  	/* Bitmap to indicate if reading the related config fields are needed */
>  	unsigned long config_read_bitmap;
>  
> @@ -471,9 +473,9 @@ static inline s64 towards_target(struct
>  	return target - vb->num_pages;
>  }
>  
> -/* Gives back @num_to_return blocks of free pages to mm. */
> -static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
> -					     unsigned long num_to_return)
> +/* Helper: must be called with free_page_list_lock held */
> +static unsigned long __return_free_pages_to_mm(struct virtio_balloon *vb,
> +					       unsigned long num_to_return)
>  {
>  	unsigned long num_returned = 0;
>  	struct page *page, *next;
> @@ -481,8 +483,6 @@ static unsigned long return_free_pages_t
>  	if (unlikely(!num_to_return))
>  		return 0;
>  
> -	spin_lock_irq(&vb->free_page_list_lock);
> -
>  	list_for_each_entry_safe(page, next, &vb->free_page_list, lru) {
>  		list_del(&page->lru);
>  		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> @@ -490,11 +490,27 @@ static unsigned long return_free_pages_t
>  			break;
>  	}
>  	vb->num_free_page_blocks -= num_returned;
> -	spin_unlock_irq(&vb->free_page_list_lock);
>  
>  	return num_returned;
>  }
>  
> +/* Gives back @num_to_return blocks of free pages to mm. */
> +static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
> +					     unsigned long num_to_return)
> +{
> +	unsigned long ret;
> +
> +	spin_lock_irq(&vb->free_page_list_lock);
> +	if (vb->suspended) {
> +		spin_unlock_irq(&vb->free_page_list_lock);
> +		return 0;
> +	}
> +	ret = __return_free_pages_to_mm(vb, num_to_return);
> +	spin_unlock_irq(&vb->free_page_list_lock);
> +
> +	return ret;
> +}
> +
>  static void virtio_balloon_queue_free_page_work(struct virtio_balloon *vb)
>  {
>  	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> @@ -871,6 +887,9 @@ static unsigned long virtio_balloon_shri
>  {
>  	struct virtio_balloon *vb = shrinker->private_data;
>  
> +	if (READ_ONCE(vb->suspended))
> +		return 0;
> +

what if suspended bit is set right afterwards?
Seems racy.

>  	return shrink_free_pages(vb, sc->nr_to_scan);
>  }
>  
> @@ -879,6 +898,9 @@ static unsigned long virtio_balloon_shri
>  {
>  	struct virtio_balloon *vb = shrinker->private_data;
>  
> +	if (READ_ONCE(vb->suspended))
> +		return 0;
> +
>  	return vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
>  }
>  
> @@ -1086,8 +1108,11 @@ static void remove_common(struct virtio_
>  	update_balloon_size(vb);
>  
>  	/* There might be free pages that are being reported: release them. */
> -	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> -		return_free_pages_to_mm(vb, ULONG_MAX);
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
> +		spin_lock_irq(&vb->free_page_list_lock);
> +		__return_free_pages_to_mm(vb, ULONG_MAX);
> +		spin_unlock_irq(&vb->free_page_list_lock);
> +	}
>  
>  	/* Now we reset the device so we can clean up the queues. */
>  	virtio_reset_device(vb->vdev);
> @@ -1130,6 +1155,10 @@ static int virtballoon_freeze(struct vir
>  	 * The workqueue is already frozen by the PM core before this
>  	 * function is called.
>  	 */
> +	spin_lock_irq(&vb->free_page_list_lock);
> +	WRITE_ONCE(vb->suspended, true);
> +	spin_unlock_irq(&vb->free_page_list_lock);
> +
>  	remove_common(vb);
>  	return 0;
>  }
> @@ -1145,6 +1174,10 @@ static int virtballoon_restore(struct vi
>  
>  	virtio_device_ready(vdev);
>  
> +	spin_lock_irq(&vb->free_page_list_lock);
> +	WRITE_ONCE(vb->suspended, false);
> +	spin_unlock_irq(&vb->free_page_list_lock);
> +
>  	if (towards_target(vb))
>  		virtballoon_changed(vdev);
>  	update_balloon_size(vb);
> _
> 
> Patches currently in -mm which might be from linkl@google.com are
> 
> mm-page_reporting-use-system_freezable_wq-to-fix-uaf-during-suspend.patch
> virtio_balloon-avoid-shrinker-execution-during-pm-suspend.patch

