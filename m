Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D24F219A95
	for <mm-commits@vger.kernel.org>; Fri,  7 Mar 2025 13:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.70.13.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741354065; cv=none; b=i3/pFdbOkz7G6tm2Uw+zkiPVZv0DRByDIBkDPdnpGmAUG7EMwVySJafQuzjDyDQs97AeR7NBfOvot2bIvXsrKn1878U5EHPkUkaoB0+7SoBpHBGMVWY5b0xN4vUpJz5df1Z3cS4kPq+JPYqBnRkrK43KBOeIfxmFA/yD7wbKW74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741354065; c=relaxed/simple;
	bh=Nu0mVFHfxBdM6hPjxlXFOrM5MzrroGavNAG/Y/53zW0=;
	h=From:To:Cc:References:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type:Subject; b=DY4JKg8UJqeuqAFTJPn8zL+Ln+SyUCNzDtkBbYLCoJp03kaipdUmVAT7ICWd1UAV00oe6+6gC9TNjED7Hi6qFOE5ssZqyl75aLrtJ4HKX8P1zpc3D+U4BLJM48NwDhmOFuw/57+lhMNcKnomcTKQbSoSeFcL11dylIgFstyjVLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xmission.com; spf=pass smtp.mailfrom=xmission.com; arc=none smtp.client-ip=166.70.13.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xmission.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xmission.com
Received: from in02.mta.xmission.com ([166.70.13.52]:55408)
	by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1tqXUR-00AWE2-7X; Fri, 07 Mar 2025 06:11:47 -0700
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:34368 helo=email.froward.int.ebiederm.org.xmission.com)
	by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1tqXUP-00GS2T-Gk; Fri, 07 Mar 2025 06:11:46 -0700
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rick.p.edgecombe@intel.com,
 kirill.shutemov@linux.intel.com, jxgao@google.com, dave.hansen@intel.com,
 bhe@redhat.com, Ashish.Kalra@amd.com, yan.y.zhao@intel.com
References: <20250304235450.87356C4CEEA@smtp.kernel.org>
Date: Fri, 07 Mar 2025 07:11:26 -0600
In-Reply-To: <20250304235450.87356C4CEEA@smtp.kernel.org> (Andrew Morton's
	message of "Tue, 04 Mar 2025 15:54:50 -0800")
Message-ID: <8734fprnnl.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1tqXUP-00GS2T-Gk;;;mid=<8734fprnnl.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX1/8yUKDphLT+UWjGzGJcfE695QKrShAOrI=
X-Spam-Level: ******
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	*  1.0 XMGappySubj_02 Gappier still
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  1.2 XM_Multi_Part_URI URI: Long-Multi-Part URIs
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_B_Phish_Phrases Commonly used Phishing Phrases
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.2 XM_B_SpammyWords One or more commonly used spammy words
	*  0.0 XM_B_AI_SPAM_COMBINATION Email matches multiple AI-related
	*      patterns
	*  0.8 XM_B_SpammyWords2 Two or more commony used spammy words
	*  1.5 TR_AI_Phishing Email matches multiple AI-related patterns
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 855 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 11 (1.3%), b_tie_ro: 10 (1.1%), parse: 1.03
	(0.1%), extract_message_metadata: 26 (3.1%), get_uri_detail_list: 5
	(0.6%), tests_pri_-2000: 48 (5.6%), tests_pri_-1000: 2.3 (0.3%),
	tests_pri_-950: 1.19 (0.1%), tests_pri_-900: 1.01 (0.1%),
	tests_pri_-90: 108 (12.7%), check_bayes: 105 (12.3%), b_tokenize: 25
	(3.0%), b_tok_get_all: 16 (1.8%), b_comp_prob: 6 (0.7%),
	b_tok_touch_all: 52 (6.1%), b_finish: 1.79 (0.2%), tests_pri_0: 633
	(74.0%), check_dkim_signature: 1.34 (0.2%), check_dkim_adsp: 3.3
	(0.4%), poll_dns_idle: 0.66 (0.1%), tests_pri_10: 2.1 (0.2%),
	tests_pri_500: 17 (2.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: +
 kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch
 added to mm-nonmm-unstable branch
X-SA-Exim-Connect-IP: 166.70.13.52
X-SA-Exim-Rcpt-To: yan.y.zhao@intel.com, Ashish.Kalra@amd.com, bhe@redhat.com, dave.hansen@intel.com, jxgao@google.com, kirill.shutemov@linux.intel.com, rick.p.edgecombe@intel.com, mm-commits@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out01.mta.xmission.com); SAEximRunCond expanded to false

Andrew Morton <akpm@linux-foundation.org> writes:

> The patch titled
>      Subject: kexec_core: accept unaccepted kexec segments' destination addresses
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
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

My apologies for replying like this, but I can not quickly find this
patch elsewhere.

This actually can not work reliably.  The problem is that all of the
state of what has been lazily "accepted" and what has not will be lost.

If anything is going to happen in the case of kexec what needs to happen
is kexec_load needs to force the system out of lazy mode and all memory
needs to be accepted before kexec load runs.

The target kernel has no way of knowing what has been accepted and
not-accepted.  I don't think you can have a reasonable expectation
that the target kernel knows about accepted memory.

Eric


> From: Yan Zhao <yan.y.zhao@intel.com>
> Subject: kexec_core: accept unaccepted kexec segments' destination addresses
> Date: Fri, 13 Dec 2024 17:54:49 +0800
>
> In TDX, to run a linux guest, TDs (hardware-isolated VMs) must accept
> before accessing private memory.  Accessing private memory before
> acceptance is considered a fatal error and may result in the termination
> of the TD.
>
> The "accepting memory" operation in guest includes the following steps:
> - trigger a VM-exit
> - the host OS allocates a physical page and requests hardware to map the
>   physical page to the GPA.
> - initialize memory content to 0.
> - encrypt the memory
>
> For a Linux guest, eagerly accepting all memory during kernel boot can
> slow down the boot process and cause unnecessary memory occupation on the
> host for pages that may never be accessed.  Therefore, Linux guests
> usually opt for a lazy mode to delay page acceptance operations by not
> moving the pages to the buddy allocator's freelists.  Instead, the kernel
> tracks memory in 4M units and places them in a zone->unaccepted_pages list
> if any page in the entire 4M range is in an unaccepted state (even if part
> of the memory range may have been accepted by firmware or the kernel). 
> When the kernel does not have enough free pages, it will move memory from
> the zone->unaccepted_pages list and accept it, ensuring that the memory is
> accepted before moving it to the freelists and being available to the
> buddy allocator.
>
> The kexec segments' destination addresses are not allocated by the buddy
> allocator.  Instead, they are searched from normal system RAM (top-down or
> bottom-up) and exclude driver-managed memory, ACPI, persistent, and
> reserved memory...  Although these addresses may fall within the memory
> range managed by the buddy allocator (which must be in an accepted state),
> they could also be outside that range and in an unaccepted state.
>
> Since the kexec code will access the segments' destination addresses
> during the kexec process by swapping their content with the segments'
> source pages, it is necessary to accept the memory before performing the
> swap operations.
>
> Accept the destination addresses during the kexec load, immediately after
> they pass sanity checks.  This ensures the code is located in a common
> place shared by both the kexec_load and kexec_file_load system calls.
>
> This will not conflict with the accounting in try_to_accept_memory_one()
> since the accounting is set during kernel boot and decremented when pages
> are moved to the freelists.  There is no harm in invoking accept_memory()
> on a page before making it available to the buddy allocator.
>
> No need to worry about re-accepting memory since accept_memory() checks
> the unaccepted bitmap before accepting a memory page.
>
> Although a user may perform kexec loading without ever triggering the
> jump, it doesn't impact much since kexec loading is not in a
> performance-critical path.  Additionally, the destination addresses are
> always searched and found in the same location on a given system.
>
> Changes to the destination address searching logic to locate only memory
> in either unaccepted or accepted status are unnecessary and complicated.
>
> Link: https://lkml.kernel.org/r/20241213095449.881-1-yan.y.zhao@intel.com
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Jianxiong Gao <jxgao@google.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Baoquan he <bhe@redhat.com>
> Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Ashish Kalra <Ashish.Kalra@amd.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  kernel/kexec_core.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> --- a/kernel/kexec_core.c~kexec_core-accept-unaccepted-kexec-segments-destination-addresses
> +++ a/kernel/kexec_core.c
> @@ -210,6 +210,16 @@ int sanity_check_segment_list(struct kim
>  	}
>  #endif
>  
> +	/*
> +	 * The destination addresses are searched from system RAM rather than
> +	 * being allocated from the buddy allocator, so they are not guaranteed
> +	 * to be accepted by the current kernel.  Accept the destination
> +	 * addresses before kexec swaps their content with the segments' source
> +	 * pages to avoid accessing memory before it is accepted.
> +	 */
> +	for (i = 0; i < nr_segments; i++)
> +		accept_memory(image->segment[i].mem, image->segment[i].memsz);
> +
>  	return 0;
>  }
>  
> _
>
> Patches currently in -mm which might be from yan.y.zhao@intel.com are
>
> kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch
