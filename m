Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C826A186E40
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 12:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212972; cv=none; b=aMWomgWmttVrjhJBG1FhOIBnhvhifnToqQMdVMZb0Zo/kBEuJJXfG1+R2dF+mrxKaX9sNOjjMfybXp4d7igq7ybxOVSbK5jB08SzsvSEIyAAd5JoiF+1psBXXFc2yZCKkdGhBfuhCZT0C1Ukdf1tR22Ti+R5QIXtfjDiVYkRT+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212972; c=relaxed/simple;
	bh=fEb4deZ8F9PZ5AlHVmFteSXdxoPeOJ5I4qZsgxELQqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FnefWAWsfeJBaBkFb+eIRpfGN1RPUgK/muy1AFmz5GBjqQ5sK2My8tASlkBEXKVY4u7UtoxibiRm5LY0vHNL18QdjCjvRB9vbPnaGSrLy0fjtrTJBBB51RrQ2VBqmPY/VyNEDyv6PcUqnL4NGSYJO/cycdX24mxIKneBhxWEt5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+DGuMwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+DGuMwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8ADC19422
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 12:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756212972;
	bh=fEb4deZ8F9PZ5AlHVmFteSXdxoPeOJ5I4qZsgxELQqI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Z+DGuMwk3C9BIieL0cgynRb1IZ1uwiUiSHVUfWV2amOyiNCCVz4Mgy0pAKsRUJyQy
	 kiSBzTgo/UFbNnIWLaGB+7Vc8cdGN8r49tn1kZf5BW6dgsovHEGfPu//2IRObwip+d
	 AijWiKhPz8mKxR/hbFtC5bAnd9OMjbkbnUe0ab3dpv3g12uHbthvIU75BtqmnT9/yj
	 wUQBONnxo0rds6yj6jOE8Hg6+WPfosHCOG0nralTyZA2Ak42nbQiGiVHgSUe/FpMbE
	 s+UyWHn7s+VioOU0p2xREVhMBtAOzkYUE3FoYqliSoxhibxTTvoefKwI2K57QAWOyR
	 1wvxsRKFmPh+w==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55f49b42180so1630043e87.3
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 05:56:12 -0700 (PDT)
X-Gm-Message-State: AOJu0YwIGhiDOYRjhHrfTBwzXTQvQVF0uWjw6LTdZSBvvwceyzSSMydC
	nBYK4okaerxPOUL2o/+hqncqqEwxP83kAOD5oGsLE2jxOp4o/IhPbQNrCCz0uZ5+iqBYdG79bPD
	gkpGFNlbkonoRTubSQIS/eMA63eTyP/Y=
X-Google-Smtp-Source: AGHT+IGWNfuSRjR7MI4ea75//OcM0GLGEi2GFTrDWn5Ieu7VOfBRUAibtFKZht0L2TSOopSXL69SAMBu9YEJD+LFKjw=
X-Received: by 2002:a2e:8a8c:0:b0:333:924d:4262 with SMTP id
 38308e7fff4ca-33650fd8690mr36073521fa.29.1756212970890; Tue, 26 Aug 2025
 05:56:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821213034.0B05AC4CEEB@smtp.kernel.org>
In-Reply-To: <20250821213034.0B05AC4CEEB@smtp.kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 26 Aug 2025 14:55:59 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG8OhR4TE013TqhFjf__nWbiF17gjSJFEbODH9wKk1b3g@mail.gmail.com>
X-Gm-Features: Ac12FXwVwgEvUBf5b_LYn8Y8TIIlUqWydyQXsnjcdxLFyTqPH2diPIS4vLZciZs
Message-ID: <CAMj1kXG8OhR4TE013TqhFjf__nWbiF17gjSJFEbODH9wKk1b3g@mail.gmail.com>
Subject: Re: + efi-support-booting-with-kexec-handover-kho.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rppt@kernel.org, graf@amazon.com, 
	changyuanl@google.com, bhe@redhat.com, epetron@amazon.de
Content-Type: text/plain; charset="UTF-8"

On Thu, 21 Aug 2025 at 23:30, Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: efi: support booting with kexec handover (KHO)
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      efi-support-booting-with-kexec-handover-kho.patch
>

Please drop this patch. Once we agree on the right approach, I will
take this via the EFI tree. Thanks.
