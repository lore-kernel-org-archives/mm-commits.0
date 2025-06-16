Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E819A2BEFE1
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 18:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750097034; cv=none; b=gvzQujuyKAz+aMVK6KQUIstSzPDPpGqw0Ztrjfs2LYfHSDi3AfirgEzzHzUJgiQ53ILncQTo71gClR8jWQtygx/JDzMQvR0dpYQs2AoqDCXi4Oje++ROfyRvpbYYbQ1PRBvTqcdZGuCekh48TFjcvg8m6gmmqRPsPEys3F7R1Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750097034; c=relaxed/simple;
	bh=8ViotD76zdcGr35xQglHR3AS6ONPqA/EM5gqqD2Voqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KSEm08CNUqn+OvY16sTWVfEEXdG4USTeq0hdf6xwXb3VPTF8sJKUeJoMOswHio4Y7Fsx2f4NYZP89vonA8JxsBS+20e9BghtsDEEKEXPp/h8kyMTsRWaYr+Acs6etBXHiuJrlR4PQpN9gOGdyOVWzb3xA2YlhIKokdl18jqevyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J4+4NS0t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UbzhAEaR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CjKpO8pj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fQrRlX4q; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="J4+4NS0t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UbzhAEaR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CjKpO8pj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fQrRlX4q"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D8A8E1F74C;
	Mon, 16 Jun 2025 18:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750097031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X0fB0X07IdHaRTiXleyg71XBuNjXZ9L5O1REp11Iq1s=;
	b=J4+4NS0t9UiuPfZOXCnX/JpG5LNp4vdHHzkL4Ocw+V6O1whZxN4AoKnkDvGmEAOkf6VxG5
	42Gwen55xaIEXBzBnBrmALvew3seHgEpTp7418PFhyUsEtd3m7WmoQSJAlEvUycvbbWcy3
	vtRvogdrxTCTAAPKaqvySiA2yAHLe8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750097031;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X0fB0X07IdHaRTiXleyg71XBuNjXZ9L5O1REp11Iq1s=;
	b=UbzhAEaRlD/n/enktbLShJ0v9tLSTcXyF+/CP3mHZ1jd8SUkEtnGLsLRWM9d9q+GVGAAho
	0bOEn6EEDjMI25Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750097030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X0fB0X07IdHaRTiXleyg71XBuNjXZ9L5O1REp11Iq1s=;
	b=CjKpO8pjl/dEDGcT2iyLY+C/HMNtJXDY62fffNNw/tn8jyNYOFYXVwYzL+eqaZgV6NweXI
	kcT/rCmCzcm2c5n+rQvIbnOpYrNu/4tOsW6XaINRSiSjiiR4rEth6f+9a3cdpi70QeuJ8Q
	WnLBSAuEPpLYjPdNCFeIEG/nnldLD3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750097030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X0fB0X07IdHaRTiXleyg71XBuNjXZ9L5O1REp11Iq1s=;
	b=fQrRlX4qtqBzmaHWqlzKUnD2VbaLimkQ5zYC1QA/RAtzRnHfeZ33KOevtmVbBwPlITbyap
	QCmc3cgCIZnnweCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2DB7713A6B;
	Mon, 16 Jun 2025 18:03:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ufRVB4ZcUGiMEQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 16 Jun 2025 18:03:50 +0000
Date: Mon, 16 Jun 2025 19:03:48 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org, 
	pulehui@huawei.com, lorenzo.stoakes@oracle.com, liam.howlett@oracle.com, 
	jannh@google.com, broonie@kernel.org, aishwarya.tcv@arm.com
Subject: Re: +
 selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled.patch
 added to mm-new branch
Message-ID: <mfcsekeqtzsoqubme6rawl6hntgchjq6nr2bzwrty2rubahpja@44o2gxxtgy4f>
References: <20250610200528.DFD48C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610200528.DFD48C4CEED@smtp.kernel.org>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Level: 

On Tue, Jun 10, 2025 at 01:05:28PM -0700, Andrew Morton wrote:
> 

Andrew,

Can you queue this into mm-hotfixes? This fix complements the one at
selftests-mm-add-configs-to-fix-testcase-failure.patch for systems that do not
support uprobes. We should also have sufficient reviews, I think.

Thanks!

> The patch titled
>      Subject: selftests/mm: skip uprobe vma merge test if uprobes are not enabled
> has been added to the -mm mm-new branch.  Its filename is
>      selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled.patch
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
> From: Pedro Falcato <pfalcato@suse.de>
> Subject: selftests/mm: skip uprobe vma merge test if uprobes are not enabled
> Date: Tue, 10 Jun 2025 13:22:09 +0100
> 
> If uprobes are not enabled, the test currently fails with:
> 
> 7151 12:46:54.627936  # # #  RUN           merge.handle_uprobe_upon_merged_vma ...
> 7152 12:46:54.639014  # # f /sys/bus/event_source/devices/uprobe/type
> 7153 12:46:54.639306  # # fopen: No such file or directory
> 7154 12:46:54.650451  # # # merge.c:473:handle_uprobe_upon_merged_vma:Expected
> read_sysfs("/sys/bus/event_source/devices/uprobe/type", &type) (1) == 0 (0)
> 7155 12:46:54.650730  # # # handle_uprobe_upon_merged_vma: Test terminated by assertion
> 7156 12:46:54.661750  # # #          FAIL  merge.handle_uprobe_upon_merged_vma
> 7157 12:46:54.662030  # # not ok 8 merge.handle_uprobe_upon_merged_vma
> 
> Skipping is a more sane and friendly behavior here.
> 
> Link: https://lkml.kernel.org/r/20250610122209.3177587-1-pfalcato@suse.de
> Fixes: efe99fabeb11b ("selftests/mm: add test about uprobe pte be orphan during vma merge")
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> Reported-by: Aishwarya <aishwarya.tcv@arm.com>
> Closes: https://lore.kernel.org/linux-mm/20250610103729.72440-1-aishwarya.tcv@arm.com/
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Pu Lehui <pulehui@huawei.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  tools/testing/selftests/mm/merge.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/tools/testing/selftests/mm/merge.c~selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled
> +++ a/tools/testing/selftests/mm/merge.c
> @@ -477,7 +477,9 @@ TEST_F(merge, handle_uprobe_upon_merged_
>  	ASSERT_GE(fd, 0);
>  
>  	ASSERT_EQ(ftruncate(fd, page_size), 0);
> -	ASSERT_EQ(read_sysfs("/sys/bus/event_source/devices/uprobe/type", &type), 0);
> +	if (read_sysfs("/sys/bus/event_source/devices/uprobe/type", &type) != 0) {
> +		SKIP(goto out, "Failed to read uprobe sysfs file, skipping");
> +	}
>  
>  	memset(&attr, 0, attr_sz);
>  	attr.size = attr_sz;
> @@ -498,6 +500,7 @@ TEST_F(merge, handle_uprobe_upon_merged_
>  	ASSERT_NE(mremap(ptr2, page_size, page_size,
>  			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr1), MAP_FAILED);
>  
> +out:
>  	close(fd);
>  	remove(probe_file);
>  }
> _
> 
> Patches currently in -mm which might be from pfalcato@suse.de are
> 
> selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled.patch
> 

-- 
Pedro
