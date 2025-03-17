Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9959B156230
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 13:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.70.13.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742218463; cv=none; b=adMdXYX+RcoeySwLb8pHyxXT58CZyYRneyIq2hCdaWRoKbl6swJCp96j7ipSfeQW/XhD2T/uXyZvyRHK6nx/VMh13CcVZa3uj4u9ZHyP4j+wc+JGQ5zLrqhxNcZpVRZ4KNCa+xd/zdiqJyTpuFmd7tIChrD5Xkz8V5hq1rzZfrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742218463; c=relaxed/simple;
	bh=e/887/EVpk280DRFgmvekhQ0VXXWb3BTgN7P90w/nzM=;
	h=From:To:Cc:In-Reply-To:References:Date:Message-ID:MIME-Version:
	 Content-Type:Subject; b=OIDOZvChrvGEQg0p/HRjOkGiz7V2WDl0si1da4C0u8SfCbRV+TwV6YQPuntZB0GiF6tfjgbsyAA4DlLrV7lTvujU3+SKc/yiY3rmTWk3ubkQsmD/0Pwm96DJetV+sJAML8ybTnQW3KPxJc2Ml7gweaf8b6pJqfCx7B3oyKQ91oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xmission.com; spf=pass smtp.mailfrom=xmission.com; arc=none smtp.client-ip=166.70.13.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xmission.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xmission.com
Received: from in02.mta.xmission.com ([166.70.13.52]:50592)
	by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1tuAbe-001WVz-AM; Mon, 17 Mar 2025 07:34:14 -0600
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:48970 helo=email.froward.int.ebiederm.org.xmission.com)
	by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1tuAbd-003e8q-CP; Mon, 17 Mar 2025 07:34:13 -0600
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com,
 jxgao@google.com, dave.hansen@linux.intel.com, bhe@redhat.com,
 Ashish.Kalra@amd.com, yan.y.zhao@intel.com
In-Reply-To: <20250317053306.59F9CC4CEEC@smtp.kernel.org> (Andrew Morton's
	message of "Sun, 16 Mar 2025 22:33:05 -0700")
References: <20250317053306.59F9CC4CEEC@smtp.kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Date: Mon, 17 Mar 2025 08:33:32 -0500
Message-ID: <871puv93yr.fsf@email.froward.int.ebiederm.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1tuAbd-003e8q-CP;;;mid=<871puv93yr.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX19RvUVCDAk7525zkOn5YX6qazqHUFEmsP0=
X-Spam-Level: **
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4319]
	*  0.7 XMSubLong Long Subject
	*  1.0 XMGappySubj_02 Gappier still
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 311 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 3.4 (1.1%), b_tie_ro: 2.4 (0.8%), parse: 0.58
	(0.2%), extract_message_metadata: 8 (2.5%), get_uri_detail_list: 0.84
	(0.3%), tests_pri_-2000: 10 (3.2%), tests_pri_-1000: 1.70 (0.5%),
	tests_pri_-950: 0.94 (0.3%), tests_pri_-900: 0.75 (0.2%),
	tests_pri_-90: 88 (28.2%), check_bayes: 86 (27.6%), b_tokenize: 3.7
	(1.2%), b_tok_get_all: 6 (1.8%), b_comp_prob: 1.28 (0.4%),
	b_tok_touch_all: 73 (23.4%), b_finish: 0.65 (0.2%), tests_pri_0: 189
	(60.6%), check_dkim_signature: 0.49 (0.2%), check_dkim_adsp: 3.1
	(1.0%), poll_dns_idle: 1.37 (0.4%), tests_pri_10: 1.59 (0.5%),
	tests_pri_500: 6 (1.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [merged mm-nonmm-stable]
 kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch
 removed from -mm tree
X-SA-Exim-Connect-IP: 166.70.13.52
X-SA-Exim-Rcpt-To: yan.y.zhao@intel.com, Ashish.Kalra@amd.com, bhe@redhat.com, dave.hansen@linux.intel.com, jxgao@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out03.mta.xmission.com); SAEximRunCond expanded to false

Andrew Morton <akpm@linux-foundation.org> writes:

> The quilt patch titled
>      Subject: kexec_core: accept unaccepted kexec segments' destination addresses
> has been removed from the -mm tree.  Its filename was
>      kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch
>
> This patch was dropped because it was merged into the mm-nonmm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>

The patch is and was broken.

My last comments were completely ignored.  Since this was posted
after my comments I had assumed they would be addressed.  Since this is
not and never has been a bug fix I assumed that nothing would happen
with this until the merge window and I had a little more time to compose
cohesive response.

All of memory must be accepted before kexec happens because nothing is
done to transfer the state of which pages are accepted and which pages
are not accepted.

The kernel that is kexec'd can't know which pages to accept.  If
anything is left unaccepted "Boom"  if it tries to accept the wrong
thing then maybe "Boom"

Please revert this broken code.

Eric
