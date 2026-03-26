Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B43826A1CF
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 12:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774526460; cv=none; b=FIc+/WRELDpbhij/z2DuJtZ180+2GPdnekRbOnCrntIEiL3zw1o1pHyVhW5EuOwHTRLWITED7kXtLnme/6wZk3k91CksfybQldCYJtrvkcFvmcS3VXFS1F6M40bsKX4RkN8ItCLuiHaj/mASGV7/szbI9OjOHr4DiyKwGe2vZn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774526460; c=relaxed/simple;
	bh=xfrdJWac3bltk9i4pAXANO0dKWQqrnbGePkoUMlWONw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=o1TZp214vtyOab44TYC+kYu/Ux15bxHGd7bSk81agwJ2mo7T6Ry04QslGcTQu0Sncum5WB8J7z51Vfc+XS4G6KH7pwXXlZp+IgZyzxdbsyVSJEID4Nluq7WVWo2fwHV7VuSfu/+HGiRpzQZ0/jSAsu3ju4MX2HWq9w90SxYniG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ih/gOGRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ih/gOGRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FB9C116C6;
	Thu, 26 Mar 2026 12:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774526459;
	bh=xfrdJWac3bltk9i4pAXANO0dKWQqrnbGePkoUMlWONw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ih/gOGRGoq68Tsrv2P/QnQ3jr/JzhXeFzS2InntU1YCTgcsil6+VCsVyre0AoNIQn
	 rS6/PiCIkxRNBrXCGQzzEIwVYeuGj7T8Baq2Xg07LlxNiP+6q3udtE610786MuPJyM
	 wuIpJgqrHXoFuPVZUoZwWGBNpd4+aC08+2Yw2SZmA61KHCS1mrlOduQo+AiWS4SiTR
	 D7z98jdv6dvO1xs4bc9Wt+FCIL9+4ZS5kEX0Uikrpex0SN7RPGSOq6d8BJo3LRsDNd
	 0aGSnySiwPNhGIgpthh/hTsBNzztv+mi6Byh1xP6BJJmAfGy/o6TSXs9Li8dsg2CJT
	 NvB3pcV90hHIw==
From: Thomas Gleixner <tglx@kernel.org>
To: Benjamin Block <bblock@linux.ibm.com>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org
Subject: Re: +
 debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects.patch
 added to mm-nonmm-unstable branch
In-Reply-To: <20260326094626.GC252856@p1gen4-pw042f0m>
References: <20260311174822.42D6DC4CEF7@smtp.kernel.org>
 <87qzp7et8k.ffs@tglx>
 <20260325115527.36034bfd3d91d6f258526c74@linux-foundation.org>
 <20260326094626.GC252856@p1gen4-pw042f0m>
Date: Thu, 26 Mar 2026 13:00:56 +0100
Message-ID: <875x6ier5z.ffs@tglx>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Mar 26 2026 at 10:46, Benjamin Block wrote:
> On Wed, Mar 25, 2026 at 11:55:27AM -0700, Andrew Morton wrote:
>> On Wed, 25 Mar 2026 18:03:55 +0100 Thomas Gleixner <tglx@kernel.org> wrote:
>> > Can you please drop this. The underlying problem is not explained at
>> > all and the question I asked vs. deferred page init is not answered.
>> > 
>> 
>> Yep, no probs, I agree that this isn't the one.
>> 
>> Benjamin, please do pursue this - the issue is real and has been around
>> for a long time!
>
> I'll get back to you both; I was out for a couple of days :)

No problem
