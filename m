Received: from sonic311-24.consmr.mail.ne1.yahoo.com (sonic311-24.consmr.mail.ne1.yahoo.com [66.163.188.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE5E18DB1F
	for <mm-commits@vger.kernel.org>; Sat, 23 May 2026 20:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.188.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779569425; cv=none; b=jQP1KIB8RCtvpBZS2RJABvBiQ8E/CJI9KUDhsswWGvtxaBfC0mcE0UXPApqpYjFIz0OvlL8iLTh0Pxb5yJklfY8vZTUqLXG/JFIIHngpMGfs/Idv1IPegd9ovuXgeZ5EoZ68TjTgoX18a5ju3ZgORHiejkkfaxGSsh0wg3nb60E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779569425; c=relaxed/simple;
	bh=rzKLp2Tsuq8nSz8MCQM1dqjTJm6JAMQ7ceLiSNfnz3E=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=O98gdD5AMCG5COIN/O6fARQLI3eQXB0TJryDQMi/WdBVvKhC7KUTPc+tuFOfaz0jfIlACXLcHmzaA2Fo7+RFiKYFz7+ozsZcHgMwY242lHuLoplSsdGFtOtiyhT8yVpOPpg7Q5J9xl3fHjDYKPXSgmWNDwwMrBeTRfpBSl/E+a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=bRvITVrP; arc=none smtp.client-ip=66.163.188.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="bRvITVrP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1779569423; bh=rzKLp2Tsuq8nSz8MCQM1dqjTJm6JAMQ7ceLiSNfnz3E=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=bRvITVrPzjBDVtjA9r/7Aw411tosLt5IIfT/K7F0GT+jvqCspIhxOeSj5R9FLc+CA7+3OS/6ACcOXiB9rrS6qdHJ8NBTE+URrMVjLHq5VGYbxv1FMsKeTl+1zPEqMcOZbjnW9tyycjxenszuNHClKEPC3ndzq0bfrZD3pu9eiqX1lHTV/Be0QYH17tYC+R+XrKBAUqET93onQqh6gNqOla8xIqpc1XW7JJXOdFrWtw3Mz1noozZTrdpvHRuICedsjto651t4Ws3KFg4iQcbNftw/X3iSyBn94iv62kSuVCdJPfpaBgUsUdjUtpl5YzVxUiJwOkN7tBdZOXxQ13c9TQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1779569423; bh=TEA8/uvK3DwIfd/MuakqX7py5JpXONoHQIa9wRoJ7+p=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=YZSd0iVMWg9Z7DnZFamtjhN0beBNgQJoA8pn4IqCIA2THLWVVCucgdtFXQAolaimVlD97O2WiEIKgM6HqjJj8sC4LFMTsYNznkkd3f2VDzUAeq5FmfXe+0HNTa2AcpJZdCd22MsxVW43g/43ty1QU6Fx/xWPvjqzTQHn3k00QSNVELirDlk31SS4RaJo6BjcsKbhhnCGsGQGrk88iAjC2k7QBfUfHtTGrGwUaLqIZ3SxOO602Q+zeWTDP57bVY3t+XrGO/Htqcq/W5t3CR0ldbAOOa0xnpFIpbK8rYPN5uAQzji3yOm7wHxafUqUaHzRW61zJj1QmDGw/z+mDkQcVQ==
X-YMail-OSG: 5rizNKUVM1krcixMHJFCU8KZVRuIHYYhZby.aDmcSlezF2obFZsvQ8OfU3QYyEC
 MzdVNOqTlz7w7935QwAz9nxYCwvCLHktYmPv4KBQKXeZrYopnrYdHqUdSbRneixUqGA63rNH8GjC
 x0yJsrhO0dszZj.75NKcPG4dDbclQZD7SuYxF5Ts1YT2RpqvarJeBXcLB4phLGpsu0fwxYVh0Rvs
 3XlCpdKaHh8jxLQAL1UrmQKjZIvn2QqBP1IJ2pMPk2knCd_i7wjGWRK6fv2eTQlP_Yf8RwDB8VF1
 zHXLPN88OA.fDpcwf4E3vIx7iL1UoCVV_vfO73IcBDHJQeaxCwNmllYCPbcbYjulKNrSt8HL0X9F
 afewZUWx1jDUH.LWYvLYSpwGwDmBCFuzHO3ERt3EOjzl6dRab6gBAaR5Cy9ZjItsjINViEzt457U
 AcQWOfBT_QJCu54xpCeRnwY7FIfWl5dhSVkGXGEmsMycKDI5CxoYArC.fHmCaG59WTXseEZy2NC6
 i0plJyXTh3n0fBOi.wI9e7f0HK4eDNI6943AyGk900OY._HwQGIQMwlYEd1m1ieZc0.2Iyl9taXe
 ohLYBHEZmVhDRpJNCm.jzV4wfAhGn38ZptwOQj4wrQkEI7..VM03ZsRCBXR0p7gX3d7aeVB_Z9VE
 iSbyhaDePbBEbeHAjkbJo.2JhnQ9ykAZqpySe4kRzhSCGHM3mawd_oHhCZeJq0ILHLn3XxH1IzWb
 c8ReAvQGfPyPaKsJinDs_N_OG3rfhDLDBSvvpIb_ujPpwbp8jS8TGE90veYT7zD43nkGiFwyj89Y
 Jrhr1eEnaNnEnWTfjcoAj2SyB98c1Ziik9z0nd.6UKWd1.VVNEQqLReSpBwixendJt_K__4vnDOU
 Rp.ZRYaq0HlU15kCMUpeILd1I1bEfWT1mmBqRUEj3yJJ8iMP2U.wd4FLliQNsGRcVkz1E4Y.yQVj
 M6Pw3wO9RboUWHGcvhrNUo82.DeJXTzRVshIwZObKG2oEFJjqVQ3MMG2PxW1MWq0mubFy5t8skA4
 OoKs3qMO55K28sKLnbepdrEcKWvJvfQSnYP4U6c7ZQlUfPtJoF9n49u_1tTXXptlgArVfYwvN6cV
 aHPtrA.sEY2mGyqVumb_6NXJJxp8kwCyQ9fIUOoBTjIEuJeFasSnwkJT89rF85ThKAmJcvFRHOJP
 FixD6BjspizEbZFSNU7jsw4xS_VrL8Vap3cvCOczP8FzW__VgOZFgL0U_X7Rz7b6wm0Xp6VFFWxk
 vFyoiZ6wX3LWyz7xBl0S0JX8tz8ze5dVEKPGp1N7Q6790Dc6qeG0Io_kWgerkp_1PefjBNQhmJ6o
 ew82wtxQSMFKBAjX1yJhalFx3aWMsnr1i9eeGU_iEwhL7z.FcBnArYKuiL40MU2JbO49vD5.bzS.
 Kee97cCdB5Ez8NBg9GHeA4kNgTK2N9o0XwmGYFZenvuC4pOMxWDiyVY2pP6RnYPbXPpheyh_jEju
 Ts0JjDfMLlkQtUT31sXpomNvE_prOJVgqpeU8Ouhg.1jzVCqHcb4bzKglCk9Hsb1.mr8Aq5SsDG2
 zWzmiPkoLYE9kipYDUSmiuvzEXaARtnkvB1ZU6qx3O0xTAurMy5MK7DIVzbxEkgpHHVNfR8Oa9Wp
 M291InSi6ih7lkNeuknPdc1SSHbNvdrfwAJWUroGo6rq6n1VrVbHXspXSmfE7vCRJqi18nuj5.IE
 x83nEOjPOTbxZyqU1RMeR2Q2XEoK6YUfuEzb488FuNiLS00ErQQXVmQZrqcWE846lIl09qZr.MYY
 W0l4Fg25J4SHP0se.t9YeoY0TkASnFVUGmV4vw4_cVCCsvRmt4PXIIr94.9G3b9xqpErdP6HQxe0
 PjoPjlUVJNBf9YU4W1XYec4DUMqNi2lLTIusZzbiSqOjW63ADqiHpTrzovp4wMdTErxb_wAlnMrO
 13UwD8_P0DRCVP4o5NSRrYWnH32Vjw7Nh84DR71csQYZR.2wL61LGMHZwLso1byRF5nwlps09Lzu
 .7uhhdbZvsnMggEaQt_bJRMc8bdAiMaWhkAMJ2JFc4XEHcgk36E3uSB15540GXBFyokmpEpYUnUw
 cnPwu0u2Q6D8JorVyECK9GdaoFtdh.PRqFMx8Dqe0xIkpF9sAmdUfsrJcZn73_fqnXm5CiDUTDKu
 Vh0ww.JwaqoB8IuqBP16pyUhOSDC.av.jc8He8cF.ulLQk_tb_MGBx8FkkhlBGfLNBUpi_XXlj06
 o0XsNlnIJVVhDgJguErHQzD7zwWmNFFhLZCuuov2W6.Y.OOJLRRimsD61LLZ8tbyxiC0-
X-Sonic-MF: <sakunix@yahoo.com>
X-Sonic-ID: 2ce0cce7-dbbf-4626-b6a3-12d2288e4d33
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Sat, 23 May 2026 20:50:23 +0000
Date: Sat, 23 May 2026 20:40:02 +0000 (UTC)
From: Manuel <sakunix@yahoo.com>
To: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, 
	"rafael@kernel.org" <rafael@kernel.org>, 
	"mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>, 
	"hansg@kernel.org" <hansg@kernel.org>, 
	"bhelgaas@google.com" <bhelgaas@google.com>, 
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>
Message-ID: <518635693.4914761.1779568802536@mail.yahoo.com>
In-Reply-To: <20260523022503.0B3221F000E9@smtp.kernel.org>
References: <20260523022503.0B3221F000E9@smtp.kernel.org>
Subject: Re: +
 resource-downgrade-resource-sanity-check-warning-to-debug-level.patch added
 to mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.25725 YMailNovation

>The patch titled
>Subject: resource: downgrade "resource sanity check" warning to debug level
>has been added to the -mm mm-nonmm-unstable branch. Its filename is
>resource-downgrade-resource-sanity-check-warning-to-debug-level.patch

>This patch will shortly appear at
>https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-downgrade-resource-sanity-check-warning-to-debug-level.patch

>This patch will later appear in the mm-nonmm-unstable branch at
>git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Hi Andrew, thank you for reviewing and accepting this patch. Much appreciated!

I would also like to express my gratitude to Rafael Wysocki for his initial feedback. His suggestion to downgrade the log level rather than using a quirk was exactly the right approach to solve this issue cleanly.

Best regards,

