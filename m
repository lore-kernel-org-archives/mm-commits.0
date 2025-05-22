Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6002882A4
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 10:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747908141; cv=fail; b=MKr/gXuv3vpu67HKm6gQwQE8PgN2Hp0F6AdcshIzPADVTP3i0z/RLhxEHWPZn24n1kTA6i25fr/ntzsVDqZA2CfrIAOnilWAHQfjxH+mt7AoSH4LJhyJoHvBdXR6Ex7ThxigwsFjTmDqwwbhbtmlsWwploBpmajArN0hnqkHyLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747908141; c=relaxed/simple;
	bh=w4E8gYYjp4eUgxM5i4+9BzxJEMniz075CG2TQSRCMXw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aodRj7TMQAsnbSWHJ2iGCbYL9cDklL637cI0BXgkHNkGirC6JPb2xo8ERgOIpresJnfFDJcjCsiFdApbAHX8NM6cNRXqaL/lDMcz9mnFWpeTp6O87d6VDE7L/QolwhqOu6ovU6HinJDe+aZUQwGFqn1vJGgeThCzB5QXdyg40BI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HPR9OtX8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cI1uiPyk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HPR9OtX8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cI1uiPyk"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9J7hl031619;
	Thu, 22 May 2025 10:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=20oQeb2yuiu+nHp8sWmVQFqDI/toGLkNgyWfIRy4XBY=; b=
	HPR9OtX8xEczdfK1g57NfdyaJRXNa3Nz2kmONflP0rtd+M8kyO+s28dP83ZnhKPE
	3oNQK/aKEhEuCJzpZFI9jFypB0oM8zRE0IuqPXnTJGUOBym1LEH7TcDsLx0jIP8v
	M4SwYIGv8w6q9EYdx76qpn97ibbk8eH4U1rj3vFQtrLRo7gdgH73ZZ5N52BZH7sS
	XSYoZ7OKuRVuXqZOeI8CO14XWsfzlmPY7Xsg0tr2NqoXalcfV9SLO5bdnt0UuupV
	WpKUkTfobrxegojWwi21bXa7GndFPIJtry591AHMtRwefEUWSWPeD8CfoCrn2OeR
	4oNjW/RuYUKlLZagddyu9g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46t0v7r2hm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 10:01:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9pF1E011266;
	Thu, 22 May 2025 10:01:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46rwep7qyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 10:01:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pCGYw+/IaRoSMXsPjLDnymadAu9IRSdOcA9Y1+Bp0ZjSf7lOhMtyZm12NxHYGArpsy6NeTt2J9vqQjxDacq+/FEHN3P5KLVf9MHaaO9MmAOmE6YqwQwahn1msOPK6CGClWl2Yug0qGwgiWXRUXoyncDCX4TqigtfMe6sUTsvmwycNXc+mMIIAXLneI+6DeVLCTJnjAeTG3qLN6WrNk7YGyhzqPcR0DpTYzBj92GrD3yDh9eQUKigzRUs/LT+6czoySGtqz8F6KAqtB5ClpxFVfuUhELdFimX3RUjkVcGHNQofqpLNBkUBFYUdepGjOT2kS6TOLJ/QIUMFyeG8g15+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=20oQeb2yuiu+nHp8sWmVQFqDI/toGLkNgyWfIRy4XBY=;
 b=p8klYjUho0I6e0XHIFNqoIdkzgNxa84GOc6k+BV8XfFST2A4DsoW6SCziUmUU6cXHDXGODAd5W5myyZSdCkslUWuud1uVLENrh6Ep8xyNbw6qndLclQ2ybqVidZA7PV12tA7810JIDZIOiZFACi9B/s/d7XvOYva7zhvf5j/UmwKQtLeIU/Kcs101Tp+lbNMXJt3R3eaJ073SMtGvRGQAE+tZvQnhGcbF3YB+HVHYknqxQinfr7tgCjjYLwxIOWT0ld/L9W415yqflMToY6oHz3KSl99VYZSO/3lBKyLwKs/hJN5+4OE/OPd+OpF/2/sIGjgVt3HV1MnL6j3gqiITw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20oQeb2yuiu+nHp8sWmVQFqDI/toGLkNgyWfIRy4XBY=;
 b=cI1uiPykDY3liwt9mSahOrcxTUWk6Hgn97YvnBFa5T6P2qSCy9vS0PV5x5fu4ZdsgPL4s+TJnQHOGzYkga5tQniq4etrtnKNAKbgEUAvRxaom4sITTkbQVEnP5k5G0CLYTl0q5/ffKfTG30WyJ0FFLI3gwHWJ1PHBFrqY9jIIYk=
Received: from DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d1f) by DS0PR10MB7320.namprd10.prod.outlook.com
 (2603:10b6:8:fe::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.33; Thu, 22 May
 2025 10:01:37 +0000
Received: from DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 ([fe80::2072:7ae5:a89:c52a]) by DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 ([fe80::2072:7ae5:a89:c52a%6]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 10:01:37 +0000
Message-ID: <27831b60-53f1-4348-b33e-1f30900e29a6@oracle.com>
Date: Thu, 22 May 2025 03:01:34 -0700
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
To: K Prateek Nayak <kprateek.nayak@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: mm-commits@vger.kernel.org, yu.c.chen@intel.com, vineethr@linux.ibm.com,
        venkat88@linux.ibm.com, tj@kernel.org, tim.c.chen@intel.com,
        shakeel.butt@linux.dev, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mingo@redhat.com,
        mhocko@kernel.org, mgorman@suse.de, hannes@cmpxchg.org, corbet@lwn.net,
        Ayush.jain3@amd.com, aubrey.li@intel.com
References: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
 <20250521191114.GE24938@noisy.programming.kicks-ass.net>
 <20250521135854.3ba2d1f61bd2c6a4af36ac13@linux-foundation.org>
 <021d2962-2fba-4c27-ae9f-4ded2df44903@amd.com>
Content-Language: en-US
From: Libo Chen <libo.chen@oracle.com>
In-Reply-To: <021d2962-2fba-4c27-ae9f-4ded2df44903@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0051.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::26) To DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d1f)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF5ADB4ADFC:EE_|DS0PR10MB7320:EE_
X-MS-Office365-Filtering-Correlation-Id: 78295dcf-0ab7-4f25-432e-08dd9917a428
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WS93ckxOZ0JlOEJDSjlDeUYybytBQ1g0K3ZpRnRBc1VrMmo1eExDWWJqejI5?=
 =?utf-8?B?MjYrRStsRDNwdDdCNEZOckhGZ0drNitkZ2FMbEZRZWlSSjZoVVhuL0xKSkFT?=
 =?utf-8?B?eVl6clhOem5zWjMrSW1WL3lrZWRBMFFtVmE2VmdDVWFuSkNoV0NJdEE0Qzgx?=
 =?utf-8?B?aVNMUVFwMUgzZkNPYzVlbVhHelBmTkxwa0R0d3NqQlRRK0R0c3owTlJSOXp0?=
 =?utf-8?B?bzdxSlAzdC9nT2x2Rzl2MmFtTmdrNWtjTEhsNE9SOUtDVmdMU3gweXhuU0FM?=
 =?utf-8?B?bGM1M2tWeFgzS0cwWmlGR0cwSlQ4Qm1RUXFzVk5meVoyRlk0QmZIbHNWdG1i?=
 =?utf-8?B?Q2lRSzYrSU1ZQWhjcVl4NStBd1RaSDhlbTZvYVVlSmIwNU1jdHVFdTFoWk9J?=
 =?utf-8?B?OGJwZWFrRnlrYkFzck1aYU1hblJ6Z2lWeDcxa0w2VHhsRmlKREREYVc4Q2Vw?=
 =?utf-8?B?WFhVSG9QSTlsY3JGcEdoYXk2QnhOb21nRGxOUWNtUzNSQk9mSnArcWRtWDhv?=
 =?utf-8?B?OFk3cmNuVjV4OFF2TU42aDlKUU5yS1hLSjV3KzV6UXMwRVo5Y1pqNGZwaE1u?=
 =?utf-8?B?QTE0bUJteTMwZWEra3ByVFJTRHRMVWYrVXFhV09TQUYwOUpFZnN6UTJkZ2VZ?=
 =?utf-8?B?ZDltNUhtUC9IUldDa3RaZmJtRlMwTWU4NmdFQWJEV0xHY2tueTdOaWx1T2hC?=
 =?utf-8?B?eUUzNExyWkxPMUhlNjYxYkZjV2J0amZOY3p2MFdRSXJiR3JhbmJxTUZlbXMz?=
 =?utf-8?B?dnVWL1dFK2N5alh2eHZvWVRkNDNQSFkvcDViVFJGbUp5ZkhRV1lNZXFMWnZB?=
 =?utf-8?B?TkowMFNhZFgrNWIxT1NqNXRpWDdYcnJqOThCNWFZV1RSQ2F4YWZrbTA3c2h0?=
 =?utf-8?B?TVJ2aWVudktMbmlEeUdBNWVMOUpNa2x1YlhtaU9Ddk9EdEp4ZHdFZkE3WXBl?=
 =?utf-8?B?RWpJMVdpdS82bEpaalg2YlYxSCtvNCtBY0VTS243TWVEb2ZQQ1d2ZzZNRW1C?=
 =?utf-8?B?RC91MUl4S3lKZWlqcy9QOXFteDdMT21McDNOZlRUK2Z2SUVHR1RaTlkvNXN4?=
 =?utf-8?B?Rzd3bGRDbVVOQUxyK3ROZXl5OXpIN0wyM2trbkdjRWRsdXRXMDZNUW1lUFlu?=
 =?utf-8?B?a2hFa2NzUjNZL2M2dktOQk40QWNyK253WWJrZDREa1lZZHR1N2p4ZWZ5YTRi?=
 =?utf-8?B?V0htRkxyMXpZRzNOUFV1L3FEdlU1YVhHSDRRenQyMHlTLytSYUJuTEx2YUFS?=
 =?utf-8?B?U1Z5Q2MrSkNRUWMraTBmTVNON1hFNWtLYloydThEVWloVENYOEcyYTVqYWRW?=
 =?utf-8?B?UTJ3ZVdjQ3RPVS9Dak9JMzNEcGFBc1lwQzlqcGl2Y1N1SE5TVmRQcW9uVmVO?=
 =?utf-8?B?aGZUVzJ5QzZ3T2pDeVV3UXFBZDlJeGg4QWpPNmdwQ0QrRldCbTJxU3BnUFlw?=
 =?utf-8?B?SC96TUYxMU9mV2xwUC9SbWc0STgrUk4yZGNZQmFsM0JTdjhmZXpPQlR1YkJn?=
 =?utf-8?B?Nk5JcUxQZm1GeW5zRVdUb3JnYnZmaGk4R1dxaWdsRlI3WmNnTFllUnZDdnJp?=
 =?utf-8?B?Vkd2SGlqbVNQVkpSbzY0VkYwQktjcmJFL3htRitlSlp6K1VDR2RuT2dETnZO?=
 =?utf-8?B?anVvSk5qUUhaUUtBRGRKV1RPd1JodFhTUzhqdC9RK0E3Nk9iSFRHeWtKbHN2?=
 =?utf-8?B?YStmQ2ZQdEtSY0IrbThpNlNNa3BKN3lMK0poSm9MWG1NTEdhNGFIZmxFaHE3?=
 =?utf-8?B?UVhvNFpRMHRuTVpaa2dObjFsME9uNXpHS05lUE9NMTE5T0ZLU2hkVnhvcEkv?=
 =?utf-8?B?djZZcjRUZ2JwWTVubG1ZZmlxWHJMek82WUR0dGE0TGhjczV3L2tTSkwveDVi?=
 =?utf-8?B?MkhJZFUzVExHaFJiQ1N4Y0thUGU2dXR2N0dpTmw0RHZLRjBucmFuOGtqYWk1?=
 =?utf-8?Q?MlUb0g3P/oU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF5ADB4ADFC.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akhTTVlNOHIvOWI2YnA2RTBJK254Q0tOMDVpUk11UkYvdURqcnN4NFBxekVI?=
 =?utf-8?B?OVljeG0rbitndmVEWDFMcGtXVnJ6elRkYXNqZlhCV1BINUxpaGw5ZVZVRXE4?=
 =?utf-8?B?SlliSnJnN01obTRtK201MmlWSlpKTkhPMmxQY1grc05wNVY4UjFmUGRZWDd5?=
 =?utf-8?B?djhLKy9qTXA4ZzB5eWpqSndpaTZqTTJGb0NFRUpKL1F0MDhSOHQyMEFVZGx2?=
 =?utf-8?B?RHNzUmZSU2ZXbktzcEFSeWJ1ZTJtaEUvaFhqZEFhbnArcit4NFIvb3RCV3Qr?=
 =?utf-8?B?b1M0TlFVdTMyZ0ZoYkVJLytvNWxaL3kza1FNQXJFMUM3bEVBaUFUY1pDaW93?=
 =?utf-8?B?UWgzTklIajVoT1o2WEprOThQSThNUU1sTjZJZFhJSVJNS1dJbjNxRFJIZTZs?=
 =?utf-8?B?dXdTWk1ldDZEUzBzNXpYVFlNSFZCUjVoamkwNGMveGdmR3dFMkx0Z1d4TzhY?=
 =?utf-8?B?OUxwQ1FCV2E3ZWU4b2FLVDRCM2JPSEMwbElPMVg3MWw5UjVXckhNUnlwTmhB?=
 =?utf-8?B?TEkrL3BSdGE1NVpxNGYzWU5lVDN6dXFnMmtLUFJ1YWh2V0I2eE9CWVVlbnJR?=
 =?utf-8?B?aHQrU3lEN2REQTMyZ1pMdTlMNUsxRVd5T2VDRUdKUVZMMUgwSGpRS3hseVVu?=
 =?utf-8?B?OHFRUTdqdzMrTDVDRmZZWWxXSWRZczNHR05ZenBiUFNjNlN4cHhCOXFpR2FM?=
 =?utf-8?B?KzZ1cUJNbEZvSmpLZk05L2o3WFdUdXJrN0hVR2tiT0dRKzE2Y3U2Y3VRMXpK?=
 =?utf-8?B?c3JtUEFzeWE2cGY0ZVo2dTFCOHd3M3B1UGxmMlVBalFoTm9mbXpSRTlYa2M0?=
 =?utf-8?B?anZtcE9ET0EvZzlwVjlyWWp4VHpLVUFqUHp4Z3RHSWxmS05WV0czNWtzek5S?=
 =?utf-8?B?WTNPMEpSM1VBQ3h5dmsxRmRPdXp5UExSYVFTVzBaK2FvRWhMZC85Mkl1Z0ZE?=
 =?utf-8?B?MGEvbHdzZUZmZEVTSnRLa3JGYURtc0VFS1NaM1JKUG5LQjY2MVJJTUN6UFQy?=
 =?utf-8?B?YWpFQ1ovVG9wRGJ1dUE1TU5LdDdtRGxheGpDbmI5eHVmbEl1TjNvZFpwMmlM?=
 =?utf-8?B?a1hxZlRBQVJocWxWWjlMdTFWb0pBOGQ3TTlrUnBxRUVaMGh6ckhrWHVtRy83?=
 =?utf-8?B?UnJIU2ZDeHB5WGM0amtjLy9UYUx0VnNPbWNGOTdJL3ZWZHUzT0tSaDVDNnNW?=
 =?utf-8?B?WFZzd2w3YjN2aEJ0ME9wQlZpeENNU29rYWk4Q2doTnNPMzNFbm45MEdBTFB0?=
 =?utf-8?B?VEJBWElMNHVFVG1PbGlGbnRKUnNPV1N4NkZWL3lSUll3UXczZ0sxbGJWb2ZX?=
 =?utf-8?B?WWRmd21ucnNOWHNvTGV1R1dBekhQT0VyNTBRaFMxZXZzOTlDVmViaUFMTEdH?=
 =?utf-8?B?b0pEemlRREUxN3RlUUZoWkZoQkI4SW5pNmQwNmpHTEJEOFRJRDA3dnlrNmFL?=
 =?utf-8?B?dGU2bldqVDFPMnZ3SlBqTVllWWVkZFdpczdPWmVCWWdkSzMwMXk1N1JiSDFI?=
 =?utf-8?B?UlNuM2pQZk5acGQ2YjdHa3ZuNHh1dnViWEN4aW9SZ0xXVVhpVlcvQTVFV2I5?=
 =?utf-8?B?MWRsSzZ6Z1FWdjkxYThFK1AxWE1jZXpxL3FhbjNKY2dwc2lJMXRsK1JGZDlz?=
 =?utf-8?B?cUpJRFEyTXhZeW9EYzlwWmpvUkphOE5hU0hUbDFQRkptMFdPRlRIaUFVbGJn?=
 =?utf-8?B?dWRQR1h3ZSs0ZXNYKy8vek1VUHYyTGNoTk0zS3p1b3NqMEZNY0xBbkIzdkRt?=
 =?utf-8?B?SkZSTVVSOEliL1BZNXJuRlBMa2xCMGJURXVpSzhRcUo0MW9DeVlPRVRvVDh0?=
 =?utf-8?B?bGxGZUhhbWtmR2FwS1ZKeUJLS1RBSWF5dVg0d0VFQ0NVTU9UbWNPTGR4UDZv?=
 =?utf-8?B?WEtyaUZucWY2cGYwWlRWc3ZDUUZsaW1obTU2UngwOGFtUStXRSthMTU5WGxS?=
 =?utf-8?B?NEpLMVRJTHJucnZaZVFLalgzYlEyVERGVkVlc2ZtRnMyemVYNTBJS0Y5bzJ6?=
 =?utf-8?B?ek9BTFI0eHNmMENHUHR5ZEE3amNwZ3RjTG1pY1g5RVgvYUFXYllPbE94Q1NF?=
 =?utf-8?B?OG44WU51N2hoNXBhUjN2NjhuSzcveVBhMy9lcVAzNFFTWGpHd0tNTzkvay9G?=
 =?utf-8?Q?QPnkh05tt/+0UxIuTttLwu9bB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jj39p07KasJn4lg9nCuWRPwnQ7TPnnajh6oKRgGeLLqZ6zETMC+RcPi3CPbAP3HkUerXkEBb86BX9z5TjalLizOAcXvg0Vwv7peEDZpJ8St0cQpHsLNA32I0yT/suWY8pSB0IZ5c37ZWsYlZoAOFjARWqHmgejYScm832eNulUVxooNNqMZTrIV4GqL8aan3lym0HYIws0IM0EwDaeAiyb05LYBowEYaG/Fv6gtTg23u4FEdhtKrAt6wHENw+pLDL0wpn7rI6u9fRFjmtPHFDu54hQZgnsH72tu482jHqdx6Wfthanh1bxOXJKkm1JLgrbPBzM30/cyp/VREndabOvuitiFNhRc6Xra7BCSeSAw2x+TFqWOOXJBoN0m+kGRT1Ms29lKR0ZgONd/B9eaZ6cTuq0wr97taTLEeyqecm5yReLsYCrLoDzRGbN4eXnw6ChMCQf8El28r/pLMXAkmi2CxwG43p52aXrpE53o8uJIs501uXRKVNlCnO+r7AEytf9Fxy+BhrqE61bNqPQVMEWi2RYGpBmQyS2p42CNb3qAZ79s4R2LMRgUdYwNEajqm7YJsBLN5+b8ukMuHIEAhTQExq9BVEBX7bzKSOCyqDQY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78295dcf-0ab7-4f25-432e-08dd9917a428
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF5ADB4ADFC.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 10:01:37.5463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3d4ORXkqwT6tLgD1leUWWaZ6gOyaLuWJovmlpcvzLdIEzGu5GYAG8eRUSv2Arj3QXgEu3xPFrVh4OGQF7KCnmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7320
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505220100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwMSBTYWx0ZWRfXzI+4JW/e4eIL VXsJOtOnsUBY32Gi692NfwOoBUMfV98P4oFePimfqZ8fmDVg5noOh+VYI3SmKelEyNqizu54QHr 3HQa72DW4bjmQMVGaAI4LYMFrLhPO4sVsksWLUdwyX9PnoIwSaVlQH22PC82MPbE5PsGMBxTu4x
 rXhpiTmUMuSZl2FjRRlgn1tHLbqshk2lKKvFDpJNj2jOEtqzU2Do1edLzED4ocQXYczSd5ZvBWa 4aupKbfhE1e1sjl31IApYxEFwIej3whKmBg4esLE3GO6t74KIyS1qs8MPO5q1A3LC6e2otPmDlB IikOxw6dYc5Ry0Ny+KIC3gHepAipBgVIRvQ4910bIFknznT4rfcdqIQwmgQDvWU681QIXw44f1v
 t6D08EgM0N4KvJ6VwYgZraAIBneY3EKiIXIoTfUFLaxDxEYqHSfbZ9hgmd82fP/FoiU+9Tlk
X-Proofpoint-ORIG-GUID: m3_mxdHjJltgXOsCKlIIKD6pQ1DB-Ndy
X-Authority-Analysis: v=2.4 cv=Fb83xI+6 c=1 sm=1 tr=0 ts=682ef604 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=CCFyFp0krRMlBB3MgNAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714
X-Proofpoint-GUID: m3_mxdHjJltgXOsCKlIIKD6pQ1DB-Ndy



On 5/21/25 23:31, K Prateek Nayak wrote:
> On 5/22/2025 2:28 AM, Andrew Morton wrote:
>> --- a/kernel/sched/fair.c~task_numa_compare-correct-check-for-kernel-thread
>> +++ a/kernel/sched/fair.c
>> @@ -2274,7 +2274,7 @@ static bool task_numa_compare(struct tas
>>       rcu_read_lock();
>>       cur = rcu_dereference(dst_rq->curr);
>>       if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
> 
> Question: Shouldn't ...
> 
>     if (cur->flags & (PF_EXITING | PF_KTHREAD))
>         curr = NULL
> 
> ... be enough?


Good point, idle thread is always a kernel thread. I think we can
remove is_idle_task() in that case


Libo

> 
> is_idle_task() checks for the PF_IDLE flag but looking at
> kernel/sched/idle.c:
> 
> - play_idle_precise() already ensures PF_KTHREAD is set before adding
>   PF_IDLE
> 
> - cpu_startup_entry() is only called from the startup thread which
>   should be marked with PF_KTHREAD (based on my understanding looking at
>   commit cff9b2332ab7 ("kernel/sched: Modify initial boot task idle
>   setup"))
> 
> Also "is_idle_task()" seems to have replaced the "(cur->pid == 0)"
> check in commit 1effd9f19324 ("sched/numa: Fix unsafe get_task_struct()
> in task_numa_assign()") which should be marked as PF_KTHREAD before
> reaching cpu_startup_entry().
> 
> Did I missed something?
> 
>> -            !cur->mm))
>> +            !(cur->flags & PF_KTHREAD)))
>>           cur = NULL;
>>         /*
>> _
>>
> 

