Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD041799F
	for <mm-commits@vger.kernel.org>; Sat, 28 Jun 2025 14:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751120751; cv=none; b=Ux4/6H5OQdq9trFFGfAQ2F9CdVxR4n7uqLLqFkE6Hdwzx+1b8cRcexlSeslxYUrMGCtJzugFXkBx2T1Vmq03sSsDD+jbomlaSsFwzWoCyNbd/n4fR9b26inesr9VBvfmD2+oWmZ1RqjOC0mvUQjHdZnrhBHg8rrXIJXuiqXqGNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751120751; c=relaxed/simple;
	bh=Kuiud1LVSyDul3SA9yGXTBuPAhKXu47MB6wmLBdMyQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JI9Jr7k1W9syP05pfEoxb3E+cIawEIJBQ9/t6MV0aL30lEjri54V31qCD/XhL4wuG33dsF/kbSOZDDEQG+XhaD1Nk/ro2Eyd3lDljFmmgvO4Fnt4YZdiF8pzchynN3RhmxEReXzcEvPXgQjfX2bfIyZA0n9lzIYUHoE9MyCiyKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLMPgz5d; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLMPgz5d"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ad574992fcaso112297166b.1
        for <mm-commits@vger.kernel.org>; Sat, 28 Jun 2025 07:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751120748; x=1751725548; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OYQH6cxALqdl39lX2Uw+TDyE/44AqTPFHjUt2c1Wris=;
        b=XLMPgz5dMJbXHcsBiUTbJX2NY2FQUTTGNUPMcG/98w0gIvEL/GWc/eXcfvPQkACHaW
         ftwh1t3p3vRQnhMt88OsJlvd3+a4Zz+CIby9ooqBlugwqlJ2TybeBrwXbD3ALZXKyuaW
         V82DNCqPGLh/K7ZzBX1Gt683XQnM/6bSK7+KtDhcPITpf7+hrrVRdDERylBRwQAtLRi0
         FhR32EOT8ifA/XWclogROmkyNvMEk5MoXhCjAzh6AgIaZ+E/jvXpgxeQlUqRx3vWtmrn
         4f0b0x9CSH42RLdiSAo/5QKPXy1s3QWP1fPHtEnsk5IfUReLu9TlQ4U5XpfV4hB7Db2n
         TB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751120748; x=1751725548;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OYQH6cxALqdl39lX2Uw+TDyE/44AqTPFHjUt2c1Wris=;
        b=Yeb1a2GK+u+m1bJlzP0LDsuiwtLbL5OG7+lLxPD5GAhrLW+6m+OxGIO0zLbfq/VUYA
         PM8Zfh0QzFKe+8WGb0ZWGAnlvRasgFUfdZ08sGeq5o67oFX+ChdwZOas+M2jeBYYRToA
         OVz+9FQKQOwFVsvdP28s6fMAFY2oRg00YY26jd++6BVEUkSSToN1sJ5Mfj/OGefNsnpv
         8WOOArd5E+BAFagKDvRtSysmcbwfqERGXhi559Onq1QAMKI7u4wNyYk6xOfYoG/0z7Pv
         YvcSrdjWWahw34Krk7WQO8qBnvU0zg0lEgqTC5ptoTd3USOPfOvlT0WnOG7HBPJ4YJ0M
         HCAQ==
X-Gm-Message-State: AOJu0YwcxEwaTzgOlMBaO6iZuBhZ+PI5YeB4UMJm1wSgzDyoVUntIpnW
	80dSuAaOn4VrH0Dvcj/FBzNB2crhA0Z2aWaZ9T1/Bb7O8xY2+//jUws=
X-Gm-Gg: ASbGncvDxMrB/RxLXPMQg49IJECGiRwwc7YPVAKEhnl8Tl2ryI2m2U78LYXrj+ENhMJ
	G/zwOW1JOhVSr05BoKNLE0hnW8aWUyNOHkzso36OPHrQ6xxYoPOJ/28vJL2QYYycs45Q+WshQkT
	CxwMNkK0/n4SOF8+7SvXzomIlgoRu/8YdF3c5eqiLlV/F0JhKGtFEFEGlXMqk23qwQjwvr9DdLw
	jNwXb43m/JJnaEaeOIc9Vi5hfGW7/swCKt3aaiqqb6OpJJWlZmOniVPrvsKSG4U6jP8OkMJ/8Xc
	H0e6KJo9mPlEUZFpK+bo34jPqgmEhBS8+afrIjDA8WMRePKY
X-Google-Smtp-Source: AGHT+IE+JkmUB91BVXQrc+xJt0Bsf5eBpvu3UrgPELXFDDKj/3VkNQHXFlQ/fWpDHRbt8m16/SDkTg==
X-Received: by 2002:a17:907:3d92:b0:ae0:da16:f550 with SMTP id a640c23a62f3a-ae35011ffcbmr656126966b.49.1751120747813;
        Sat, 28 Jun 2025 07:25:47 -0700 (PDT)
Received: from p183 ([46.53.249.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c0138bsm316734966b.85.2025.06.28.07.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jun 2025 07:25:47 -0700 (PDT)
Date: Sat, 28 Jun 2025 17:25:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yebin10@huawei.com, willy@infradead.org,
	vbabka@suse.cz, tjmercier@google.com, shuah@kernel.org,
	ryan.roberts@arm.com, peterx@redhat.com, paulmck@kernel.org,
	osalvador@suse.de, mhocko@kernel.org, lorenzo.stoakes@oracle.com,
	linux@weissschuh.net, liam.howlett@oracle.com,
	kaleshsingh@google.com, josef@toxicpanda.com, jannh@google.com,
	hannes@cmpxchg.org, david@redhat.com, christophe.leroy@csgroup.eu,
	brauner@kernel.org, andrii@kernel.org, surenb@google.com
Subject: Re: +
 selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping.patch
 added to mm-new branch
Message-ID: <33155f3a-e024-4951-9f13-4c9aaefb4972@p183>
References: <20250624200802.0E2F8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250624200802.0E2F8C4CEE3@smtp.kernel.org>

On Tue, Jun 24, 2025 at 01:08:01PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: selftests/proc: extend /proc/pid/maps tearing test to include vma remapping
> has been added to the -mm mm-new branch.  Its filename is
>      selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping.patch
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
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Suren Baghdasaryan <surenb@google.com>
> Subject: selftests/proc: extend /proc/pid/maps tearing test to include vma remapping
> Date: Tue, 24 Jun 2025 12:33:55 -0700
> 
> Test that /proc/pid/maps does not report unexpected holes in the address
> space when we concurrently remap a part of a vma into the middle of
> another vma.  This remapping results in the destination vma being split
> into three parts and the part in the middle being patched back from, all
> done concurrently from under the reader.  We should always see either
> original vma or the split one with no holes.
> 
> Link: https://lkml.kernel.org/r/20250624193359.3865351-4-surenb@google.com
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: "Paul E . McKenney" <paulmck@kernel.org>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Thomas Weißschuh <linux@weissschuh.net>
> Cc: T.J. Mercier <tjmercier@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Ye Bin <yebin10@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  tools/testing/selftests/proc/proc-pid-vm.c |   92 +++++++++++++++++++
>  1 file changed, 92 insertions(+)
> 
> --- a/tools/testing/selftests/proc/proc-pid-vm.c~selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping
> +++ a/tools/testing/selftests/proc/proc-pid-vm.c
> @@ -663,6 +663,95 @@ static void test_maps_tearing_from_resiz
>  	signal_state(mod_info, TEST_DONE);
>  }
>  
> +static inline void remap_vma(const struct vma_modifier_info *mod_info)
> +{
> +	/*
> +	 * Remap the last page of the next vma into the middle of the vma.
> +	 * This splits the current vma and the first and middle parts (the
> +	 * parts at lower addresses) become the last vma objserved in the
> +	 * first page and the first vma observed in the last page.
> +	 */
> +	assert(mremap(mod_info->next_addr + page_size * 2, page_size,
> +		      page_size, MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
> +		      mod_info->addr + page_size) != MAP_FAILED);
> +}
> +
> +static inline void patch_vma(const struct vma_modifier_info *mod_info)
> +{
> +	assert(!mprotect(mod_info->addr + page_size, page_size,
> +			 mod_info->prot));
> +}
> +
> +static inline void check_remap_result(struct line_content *mod_last_line,
> +				      struct line_content *mod_first_line,
> +				      struct line_content *restored_last_line,
> +				      struct line_content *restored_first_line)
> +{
> +	/* Make sure vmas at the boundaries are changing */
> +	assert(strcmp(mod_last_line->text, restored_last_line->text) != 0);
> +	assert(strcmp(mod_first_line->text, restored_first_line->text) != 0);
> +}
> +
> +static void test_maps_tearing_from_remap(int maps_fd,
> +				struct vma_modifier_info *mod_info,
> +				struct page_content *page1,
> +				struct page_content *page2,
> +				struct line_content *last_line,
> +				struct line_content *first_line)
> +{
> +	struct line_content remapped_last_line;
> +	struct line_content remapped_first_line;
> +	struct line_content restored_last_line;
> +	struct line_content restored_first_line;
> +
> +	wait_for_state(mod_info, SETUP_READY);
> +
> +	/* re-read the file to avoid using stale data from previous test */
> +	read_boundary_lines(maps_fd, page1, page2, last_line, first_line);
> +
> +	mod_info->vma_modify = remap_vma;
> +	mod_info->vma_restore = patch_vma;
> +	mod_info->vma_mod_check = check_remap_result;
> +
> +	capture_mod_pattern(maps_fd, mod_info, page1, page2, last_line, first_line,
> +			    &remapped_last_line, &remapped_first_line,
> +			    &restored_last_line, &restored_first_line);
> +
> +	/* Now start concurrent modifications for test_duration_sec */
> +	signal_state(mod_info, TEST_READY);
> +
> +	struct line_content new_last_line;
> +	struct line_content new_first_line;
> +	struct timespec start_ts, end_ts;
> +
> +	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
> +	do {
> +		read_boundary_lines(maps_fd, page1, page2, &new_last_line, &new_first_line);
> +
> +		/* Check if we read vmas after remapping it */
> +		if (!strcmp(new_last_line.text, remapped_last_line.text)) {
> +			/*
> +			 * The vmas should be consistent with remap results,
> +			 * however if the vma was concurrently restored, it
> +			 * can be reported twice (first as split one, then
> +			 * as restored one) because we found it as the next vma
> +			 * again. In that case new first line will be the same
> +			 * as the last restored line.
> +			 */
> +			assert(!strcmp(new_first_line.text, remapped_first_line.text) ||
> +			       !strcmp(new_first_line.text, restored_last_line.text));
> +		} else {
> +			/* The vmas should be consistent with the original/resored state */
> +			assert(!strcmp(new_last_line.text, restored_last_line.text) &&
> +			       !strcmp(new_first_line.text, restored_first_line.text));

Pro-tip: long asserts with || can be written as

	if (cond1) {
	} else if (cond2) {
	} else {
		assert(false);
	}

and long asserts with && should be written as

	assert(cond1);
	assert(cond2);

so that you know which one is broken when it happens.

But maybe not, if you're printing buggy contents anyway.
