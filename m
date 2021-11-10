Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5664FC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 10 Nov 2021 07:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C4461186
	for <mm-commits@archiver.kernel.org>; Wed, 10 Nov 2021 07:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhKJHZg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 02:25:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229573AbhKJHZf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 02:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636528968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gZn653tmhlO/uD2u3PHGRlJ/GnJ2ak9IFzVldJMm4D0=;
        b=ht8lNVEQAracHk6WSXDjshofRUx2piti20CXe2Ava7xqBYSGk3XbihP1GYxLccrXxNyuci
        SnIsjQ74KoVDsqZBjaQJq+iyam4ll6CggZz6JShbg8JEeVq7vgdOb8IqOQl8JeWXDeHP1v
        7OEl7RMRn60ko3bMvjza3ZBzZN3/HFk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-q6KKVmILPVq6fsq-RnjvVQ-1; Wed, 10 Nov 2021 02:22:44 -0500
X-MC-Unique: q6KKVmILPVq6fsq-RnjvVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40D77824F88;
        Wed, 10 Nov 2021 07:22:42 +0000 (UTC)
Received: from localhost (ovpn-13-27.pek2.redhat.com [10.72.13.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0356260C0F;
        Wed, 10 Nov 2021 07:22:28 +0000 (UTC)
Date:   Wed, 10 Nov 2021 15:22:25 +0800
From:   Baoquan He <bhe@redhat.com>
To:     david@redhat.com
Cc:     boris.ostrovsky@oracle.com, bp@alien8.de,
        Andrew Morton <akpm@linux-foundation.org>, dyoung@redhat.com,
        hpa@zytor.com, jasowang@redhat.com, jgross@suse.com,
        linux-mm@kvack.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com
Subject: Re: [patch 08/87] proc/vmcore: convert oldmem_pfn_is_ram callback to
 more generic vmcore callbacks
Message-ID: <20211110072225.GA18768@MiWiFi-R3L-srv>
References: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
 <20211109023148.b1OlyuiXG%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109023148.b1OlyuiXG%akpm@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 11/08/21 at 06:31pm, Andrew Morton wrote:
> From: David Hildenbrand <david@redhat.com>
> Subject: proc/vmcore: convert oldmem_pfn_is_ram callback to more generic vmcore callbacks
> 
> Let's support multiple registered callbacks, making sure that registering
> vmcore callbacks cannot fail.  Make the callback return a bool instead of
> an int, handling how to deal with errors internally.  Drop unused
> HAVE_OLDMEM_PFN_IS_RAM.
> 
> We soon want to make use of this infrastructure from other drivers:
> virtio-mem, registering one callback for each virtio-mem device, to
> prevent reading unplugged virtio-mem memory.
> 
> Handle it via a generic vmcore_cb structure, prepared for future
> extensions: for example, once we support virtio-mem on s390x where the
> vmcore is completely constructed in the second kernel, we want to detect
> and add plugged virtio-mem memory ranges to the vmcore in order for them
> to get dumped properly.
> 
> Handle corner cases that are unexpected and shouldn't happen in sane
> setups: registering a callback after the vmcore has already been opened
> (warn only) and unregistering a callback after the vmcore has already been
> opened (warn and essentially read only zeroes from that point on).
                               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I am fine with the whole patch except of one concern. As above sentence
underscored states, if a callback is unregistered when vmcore has been
opened, it will read out zeros from that point on. And it's done by
judging global variable 'vmcore_cb_unstable' in pfn_is_ram(). This will
cause vmcore dumping in makedumpfile only being able to read out zero
page since then, and may cost long extra time to finish.

Please see remap_oldmem_pfn_checked(). In makedumpfile, we default to
mmap 4M memory region at one time, then copy out. With this patch, and if
vmcore_cb_unstable is true, kernel will mmap page by page. The extra
time could be huge, e.g on machine with TBs memory, and we only get a
useless vmcore because of loss of core data with high probability.

I am thinking if we can simply panic in the case, since the left dumping
are all zeroed, very likely the vmcore is unavailable any more.

......
  
>  static bool pfn_is_ram(unsigned long pfn)
>  {
> -	int (*fn)(unsigned long pfn);
> -	/* pfn is ram unless fn() checks pagetype */
> +	struct vmcore_cb *cb;
>  	bool ret = true;
>  
> -	/*
> -	 * Ask hypervisor if the pfn is really ram.
> -	 * A ballooned page contains no data and reading from such a page
> -	 * will cause high load in the hypervisor.
> -	 */
> -	fn = oldmem_pfn_is_ram;
> -	if (fn)
> -		ret = !!fn(pfn);
> +	lockdep_assert_held_read(&vmcore_cb_rwsem);
> +	if (unlikely(vmcore_cb_unstable))
> +		return false;
> +
> +	list_for_each_entry(cb, &vmcore_cb_list, next) {
> +		if (unlikely(!cb->pfn_is_ram))
> +			continue;
> +		ret = cb->pfn_is_ram(cb, pfn);
> +		if (!ret)
> +			break;
> +	}
>  
>  	return ret;
>  }
>  
......

