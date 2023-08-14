Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E1AC04E69
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 12:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjHNMLV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 08:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbjHNMLM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 08:11:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82011995
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 05:10:55 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37EBt6Rt029052;
        Mon, 14 Aug 2023 12:09:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=/A2QLzvWML7+M5KlUPywJnE2rXr0/ssEQfombGvrs0g=;
 b=BG69VpMTyhA5j+jieacLpxfQ+UH1GFfRbHvmGRu53erQ3EuhrjRN4cOfiQGV+5G/5Z5S
 atFmH171JqXz5ZNuNuhy6r+xA0GUSmysykhr/pR5fJ9jno5EpdQH/RY7O4oEseXhh2yS
 8efyAcQ/mSKPQ5uAkxq+rhRxrfUbCsGgWyuQvuOq6+SEbGEUv09/qb0mZAhh5050nR+N
 dOA3dkaMs1bPrSb7+lc00hYLZW8lleblS2Cyvx/QYeJRmzcIMrkKcY7hMgbF9S5HwmAj
 olIn1I3xRDef/c812BsILCeWvURmvErLei2ue3XQ1IUT9LLvYv+aXxajnXjiiLZAc8m3 jQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se349af6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Aug 2023 12:09:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37EBZgLc039517;
        Mon, 14 Aug 2023 12:08:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sey6xt44b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Aug 2023 12:08:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xjr8W8kj4aT1dt/Isd4aIsldCWrOq8xcDS0b6QcELOzglGohwGZBLokhf5zu0YPjdc2XTT/J6W3PDqvFSxu2nc0OoMjI2Z/eTcMqp1jnT0VLp/INaXSnn8Ue+Bq3htY+dmfITF8isMpNX448Gj5fnlrZ40UpZz8l33jtGhTNRUJDnuzYLK1kbgWnXhZ3BTGjkzAC5idPj5YfMGQmLFGLfZYp1urKXCGRc89PVsSXCwHuqjwa8pm4AOokSvlLxzETop4dyNkrqEMvOs/d9B0zjyBXV7sVi6EtfKiQ/LeJRWcSdIMOgYrS0kmLdVVaM0pU0u8Y7ChvexXh7mD53E2Png==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/A2QLzvWML7+M5KlUPywJnE2rXr0/ssEQfombGvrs0g=;
 b=fpKGVMKnKBfq5+waDl+9QQmghC/DdlppMfM91cX0ORJnvhZ/J9O9mxbAhe8mt3oswVAPW3cY1bMss7EnQo0K++HxsgDsHXfw9/4YNynkfdHsWS/fL0had/OiU9lH1XibQSGWix8eKa7GsNJL9HkxeZnCYA+Ub9sNYCSwpMf581mqd69nSy6/rty0Id2VsU5Xv77JI+rf+nAPEQZhesKybAbqMA9yhXd4PnTi14F3Xf+zzal2SP8ZYWEpus32buGYo5WofljWHsEscEmfXBspCRTFDe/vp/DbPjat73RTaOQhsnx0npHjzf+chJs6x9R+lEJuQIBFFhAzO26DOQ2AqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/A2QLzvWML7+M5KlUPywJnE2rXr0/ssEQfombGvrs0g=;
 b=VnJFEZoGXV0ab4c6FQYc6aIdLMZYHDfdguyMg+WTGvF71poHCMjTn4+btf2/S6ng5yyBZWCvoXbainPQsv9E3synozLV2tzqCYQqaz+iesxUU6Xqf9ZzO42Z1FI1sqdoNWJLHYAnqTjXgzH8yHCkuuBOnnN4rYcjtHkOL2UWdYI=
Received: from CO1PR10MB4531.namprd10.prod.outlook.com (2603:10b6:303:6c::22)
 by MN2PR10MB4158.namprd10.prod.outlook.com (2603:10b6:208:198::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Mon, 14 Aug
 2023 12:08:55 +0000
Received: from CO1PR10MB4531.namprd10.prod.outlook.com
 ([fe80::be4f:55e6:89c5:4f57]) by CO1PR10MB4531.namprd10.prod.outlook.com
 ([fe80::be4f:55e6:89c5:4f57%4]) with mapi id 15.20.6678.025; Mon, 14 Aug 2023
 12:08:55 +0000
Message-ID: <eb3df6ae-c713-9b42-e6ae-562e0cefdd4b@oracle.com>
Date:   Mon, 14 Aug 2023 07:08:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [merged mm-nonmm-stable]
 kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
 removed from -mm tree
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, ziy@nvidia.com,
        ysato@users.sourceforge.jp, xin3.li@intel.com, will@kernel.org,
        tsi@tuyoix.net, tsbogend@alpha.franken.de, tj@kernel.org,
        thunder.leizhen@huawei.com, tglx@linutronix.de,
        svens@linux.ibm.com, sourabhjain@linux.ibm.com,
        sebastian.reichel@collabora.com, samitolvanen@google.com,
        rppt@kernel.org, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
        paul.walmsley@sifive.com, paulmck@kernel.org, palmer@dabbelt.com,
        ojeda@kernel.org, npiggin@gmail.com, ndesaulniers@google.com,
        mpe@ellerman.id.au, mingo@redhat.com, mhiramat@kernel.org,
        masahiroy@kernel.org, linux@armlinux.org.uk,
        linus.walleij@linaro.org, konrad.wilk@oracle.com,
        kirill.shutemov@linux.intel.com, kernel@xen0n.name,
        keescook@chromium.org, juerg.haefliger@canonical.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        hca@linux.ibm.com, hbathini@linux.ibm.com,
        gregkh@linuxfoundation.org, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        frederic@kernel.org, deller@gmx.de, dave.hansen@linux.intel.com,
        dal.ias@libc.org, christophe.leroy@csgroup.eu,
        chenhuacai@kernel.org, catalin.marinas@arm.com, bp@alien8.de,
        borntraeger@linux.ibm.com, boris.ostrovsky@oracle.com,
        bhe@redhat.com, arnd@arndb.de, ardb@kernel.org,
        aou@eecs.berkeley.edu, anshuman.khandual@arm.com,
        agordeev@linux.ibm.com
References: <20230812220523.89DECC433C9@smtp.kernel.org>
From:   Eric DeVolder <eric.devolder@oracle.com>
In-Reply-To: <20230812220523.89DECC433C9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0192.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::17) To CO1PR10MB4531.namprd10.prod.outlook.com
 (2603:10b6:303:6c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4531:EE_|MN2PR10MB4158:EE_
X-MS-Office365-Filtering-Correlation-Id: 23988687-bdd2-4645-e743-08db9cbf3ad7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0FmXrJSgjVplzwxr4Hd7+NNhb/Ka0bFwXiOSYt4hm7mkUf+CuzcuUasKvLgnlzaTdttNOMNoA9XiV/0sKyFXxwiRcX5ydipUwQ4UmxuIp91Ee9X60pstVFs9XVIBeWEPwb/Nl/idDeP26zex5IH3pck5557UhCP+kuGJXbWGrX9NFR0lqg4++0lMTsKH+Aoi4h43PCChivWEL8wcyubHG+vwaSsw359IYcAAuQnjqqVotnHVQhBDX4bNe0gI0xccX6KXWoNwLecw1qCYYV1cwlbNQNN4wUZKWsus4KHxWJgjzshfHjvS8SiBjcRUg43mSk2hMH8XraxePVSbTlxkdhzw2ogkM8jt/n3ffPSeSAkQ/MPxCDxLRQeby2p3fgBhdk5VCzgZk9AJudtGgigROVWM/ACeIbBpsveYF5DB8pOptGPakMSuAeVTEUhloN4fB0Dn+4dKAo3d4nNNxV79kg1X+T4bXYiFh93ukgZleqYSnhTjABsx/FM2tmueQlgyUB0heYWE+7eggGrZp/+1Q82ozGgsHoC0DQE4pQCVRG61NfuspoYUKPcmj1hY9owoW3qiB/iLeU4sh3xFa4SqMrA/w9VLYJ5la2TlfZSnVbfEOEPh1fO5H7EkNmAxfVJVIvrT4TLu1DLIYRRDaveB86YUTvkBpDqX5DxQpBtalkWN+VBVx2j0DIiM8sgNrhP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4531.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(376002)(366004)(39860400002)(1800799006)(186006)(451199021)(53546011)(26005)(6506007)(41300700001)(8936002)(66476007)(66556008)(66946007)(316002)(8676002)(6512007)(966005)(31686004)(2616005)(83380400001)(66574015)(6666004)(6486002)(478600001)(38100700002)(31696002)(30864003)(36756003)(86362001)(921005)(5660300002)(2906002)(7406005)(7366002)(1191002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVl4VkpMTzV0WW8vekVoVWlRaFlZV3hCMDE0bC9QMlVFR2RPNGdWVU1OQVFJ?=
 =?utf-8?B?eE5ZdXF0Y3hCMkFMS1R1ZHcwNy9sRm5veHd1Rk5HdllndFpMZTRUWVU3aUJZ?=
 =?utf-8?B?QXJsSmdOMm1NMG44TDJTajBSMXh5VzczakVaMnRCVXorcUZLd3pQSlVoSWhm?=
 =?utf-8?B?UDFpQVVmSEl0VnVieEVjRTNsS2JFY3FrT2s3UWsvNUd3SGtiaDYzV3krZEVR?=
 =?utf-8?B?UFgyTGxvck9GQ0Qvc3V3ZEFHSDB1bmV3MDhaNEVnZG1jUUwrbnBUcUc5UGZV?=
 =?utf-8?B?dTRwNDl6S0dyVlRkNGxjVlNuaVI0LzUzRlFYV0VWdUJXRUYxYmdScTZEdkRO?=
 =?utf-8?B?RERpdkdLY0VvSlJCYWpEcEJmMEVFWGxvUkVDSCs0VU0rTEQ2Q0tnS1FKSGxt?=
 =?utf-8?B?dHZCOUJWVzg0WlpSYjRjcXQ5VW5FQmxBdCtjdS9jYm02ZFBUVnVpTDM3eEVH?=
 =?utf-8?B?eTVuOG1VaUI0NyttMHRDNUdkY1BWVlYxUW1ZU1l1TXZYV2R6SEJvY2k1NEhT?=
 =?utf-8?B?Q1lSUFJ6cVdpdS80T01UbGo2YUdKOG5qUWFuQ1hoTWpnMWJpV2lza1I3TmZC?=
 =?utf-8?B?TGMrdUpyRkhqQ0ZDVklCOU9LQTdKdlhKblZEcjdVdE5oQXE1SC93THRoS3Bz?=
 =?utf-8?B?Z21rTHhIZkE3Qk1pMjRmRytSYzhJcWNwZUFtNmpFa0JFcXN4TWh2QVVDOWo1?=
 =?utf-8?B?U2dpVkNpUmhlSy9VVDcvU1IwSXNZMkUxTDJNNUE2QkQyTDZBdlJiaCtTc3h4?=
 =?utf-8?B?ZDdBSVNTVGRTQjJsZ0prM3NLUUsxNDFUWHYxRURCT0tsWG4wZ1hUbUpDOGFs?=
 =?utf-8?B?UmtTcTdieG90aVFRQTV0SzdrWVdkbUR4N3RLYmlaRXU2ZWtkczh3Zk1Tb1RX?=
 =?utf-8?B?TFcwakxhaCtGbm5sUSt1YjkxQklQVndxaDNOTXRWNjF0ZTM3ZEVzY2x3cFE3?=
 =?utf-8?B?bldXY0w1RS9vY2FmUXp0ZzhEbTRmaExUTGNNcmpndTJkSldJYk01aWl4N1JJ?=
 =?utf-8?B?Z0U0RUhNSjF2dTNuTEZpcUhJTmlLeldlanNsOGx0THdRU0EzaFlMSWJTTURk?=
 =?utf-8?B?Vjc4N2pBbTkxMHdCNW81NVN5Y2ZjNGtNK1pwN09KYkpxNi9Mc0tqTmRvbThU?=
 =?utf-8?B?ODJML3FkQkd5UnhMemJrRnF4YW1MSVYzNEs0YVNzZXlQWUUwUXk4TTl0Umdv?=
 =?utf-8?B?a3dhemJuNEppcVZkUDhBM2VBZ2g0ZHlPRFIwTHpsc1RjZjM4MEpxSFpYYzZV?=
 =?utf-8?B?WXRabzJOYXlNT0d6V1VXUUlrVFl3M21UZkZiMjJNcWh0S2hzdVp6N0twRk94?=
 =?utf-8?B?ell5Yk85TW9TOFM4K2IrSktqKzhuamhVdzZYYnU0R3ZGNDFFMHNhUDRteTNL?=
 =?utf-8?B?a3RtSjltemxsamk1bTlEcnFrRVdUWnFvMHFWVlhsT25SMmY2eEVIbEhwVjRI?=
 =?utf-8?B?OEpXb3RNSGxhNVBvMmptL0F0VUwrcnJRSm9DYmF5OGVBUG1OV040Zk51cnBm?=
 =?utf-8?B?YnhaWERlWW1vSlFtVW9BN0xvSTM2TFhENmxYOW1rL3hEOHZRcm9mK09qNk8r?=
 =?utf-8?B?b0duMjhNTUtoRXFrN09uZ1FwaUxGS2I3ZUZYYThuK1d4TFVoL2hmVmI3anc1?=
 =?utf-8?B?YXUzenB4aWFQcXhlOU9mRGIrZTNDanBucnJaR1AxeVNxRmFkRnViTmhnWDM5?=
 =?utf-8?B?N0tLUExPZHpHcVNMcHpYVk1WSWhHekthMFF6Q0hYaExHMVZTc01pVVBDODlu?=
 =?utf-8?B?bUtnWmRLZ29PdFNRS2s4L2l4Q1hEQVo3akl2b09wbk15Vm1xQ2dpTnBnajBQ?=
 =?utf-8?B?dExsZTRWR1FnbEVHVmZleFpRYlFSWGpxS2RzNmRHaDl1NGlLT0lTYU5FUDlq?=
 =?utf-8?B?UlpiTkkzTXNiTjVXU2h1Um9tSENEbks3RUNPbEFuMFJoa2NUeHpERGRTZEw3?=
 =?utf-8?B?SVlGVldYQXBhRUVOeEphdWN2NjNvRkY3T0I0TTUvNnhMc0paTmoyRVpVVzFx?=
 =?utf-8?B?ckg5WFNhQ1NSbWhzNWNUWi9CUm1UdEYvdkppSkpwTTBndmdDcFNCOGMxVDBV?=
 =?utf-8?B?YTdBY2hoVmhWODFtNjd4WktKb3VtQzQ3M3BHMyttY2V1Wk1UUDlMQUZZZnl5?=
 =?utf-8?B?ZUZ0RXgxd01YdjNsM3dsV2hMYWVKc3EreHErbmNsNU9jbVVDeEpFQ3NvMEFr?=
 =?utf-8?B?Y2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YWlXNlk5cGhkZWVVVlhwek0zeDVReEtMeHRBaXZJQndYTUdZSXptd3U0Mklm?=
 =?utf-8?B?c3NlUHRkNkd0MGM0OGZ4OVpjTlJoY1FMMnRVckZOc3ZDWmEyOXhYZmprVVZN?=
 =?utf-8?B?TzZWK2hGTlNJRGtRZVpHbG84b0NKZVNqOUlNNmZYLy9TeXVObnVldkJPTlhi?=
 =?utf-8?B?ZkNubmExeE9TZ1NyWDRBWlNMQklrbG5kZ2VCL2tnQU9LNE4rTzVHT1NzZ3ls?=
 =?utf-8?B?ZkEweUdUQUZoSXNiZEFLZWgwS0xLVExZQzRQd2RzYnBLOW9KUmlVZjVVSEF1?=
 =?utf-8?B?TnNZMlU0SllWMkpYMGwvbXlXOUpUZkY5OUlpdFRVLzIvWUZmam1Ya3drRzZO?=
 =?utf-8?B?QitKTHY3c1lnUzZvbVpOQUxCek5rVGVkRktrcmpsenlvYlRjSDFlWUFIdzRm?=
 =?utf-8?B?VFJmaVNuTFFjNE5pTFBWNDcwODA1bDdWZjJ5aTc2QjJ0K2wvTjJtZTRhMUVD?=
 =?utf-8?B?NEpadGhRSEkzaXVFeU9BQTlWREFoZGFXQk9vaDRqcXZYZmJFWkV5MEtaSEV2?=
 =?utf-8?B?RVppWkhaRzlOdVN6OGFjcFJlNzR0WjdnNUtVeUxyRHN4YWJqWmU1SWVMSkJI?=
 =?utf-8?B?Y0Y5Nlh1R2NEb0xxTXkrbm9YcThtNHg1Mzh4cGdiSkJjRW9PTW9CSmllM3Rm?=
 =?utf-8?B?cmZ2aHZDTG5iUU9FYkRvYWcwNFZDV3pLd3UyV3pEbHFIZ1lCbDZKeEsrWkdO?=
 =?utf-8?B?ZFFUUlZFNGFVYnlTTmFlMWp0dlByYndQVVY3dkt3YzlrZGNXRy8vV0FCVGhP?=
 =?utf-8?B?R1JsblBDVWZqTXEzbi95aEpJOUtRNEt5bG1FN3VsMzZJSlc0d2xhT09yYU85?=
 =?utf-8?B?c1czQ0ZGOUE5UjBLVmVHbHlJVWdYQXQ4Nk83bkFTVHk1UnROZWhucjl2Qndy?=
 =?utf-8?B?SnBEOFBTd0ZVbFZHSXVlOC9aZjBiSEJoWlYyNTNHeEl4NkJraXB1SzlnUklU?=
 =?utf-8?B?SjkyUjUrYjFZSzlXNEpDR1pDSkZDTVpOMFFWRWFCQ3ZzR3RsTlBzSmszTFVF?=
 =?utf-8?B?N1NsOTRvS2NDTEtoUWN3d1Y3THNwYWhpY21lSG5aZVphV2w2UHdhM21mbXJ2?=
 =?utf-8?B?ZW9ZVDdSZ3NkSlpDQ0VQUTZvU0ozMStCTHFEdU55MkFiVm5DbE1aTVZUV0Y2?=
 =?utf-8?B?YVFNakR5VHRZZUJEd3puUkpDYjVWU01pTXZ2Zyswci9TZ2FBYlE0SlRsNkRC?=
 =?utf-8?B?azlyMHh1cDQzTkc0N1Z2MWczN2t4Z2FBVDY5K0JMVE1MRWlnWmVNbXB1TzI3?=
 =?utf-8?B?Ujk0UWFUd1ZueUlGRnRNdEI4bnZ2ZXJUbVlSY2JOTngwcldEbTRVdmNqSjFs?=
 =?utf-8?B?a1Y2azVYQzRWcFFJRTByRm5aUGFQTzNiTjl2Z2NmNUl0WnozSys0VFJuTDNY?=
 =?utf-8?B?Vy9GWFJBWk9OUUhBcEEzRGZidFNxZk1ZQkFMbUpMd1R5ZkVtM0JOS0xPV1la?=
 =?utf-8?B?VU56VnhZREIrcnBidUhOUmlvWUU0NnNJV3dTUS9PQ3pjTndRdXVFc1g3c1R3?=
 =?utf-8?B?WkF0UU1YMTE0b1Exc0paNWJNUkRXRHBxVXRyNHJTcWM2UHJLZldyK3dMVkZn?=
 =?utf-8?B?U1NDYmdiSWoxRWZjOGd6ZkdsLzl4SHFzUzZ6Mnk5bUpLeUpoUHVBUWVLUExM?=
 =?utf-8?B?eUxkUzhrekthV3N5d2xPZEh5S0orZUpJK2RyZy81S0hpdjhnOHRWZ3VKZWUw?=
 =?utf-8?B?dkd5d2tpcXFFVVpmcUtpaTBkMFQ0d3VGekQxNFE0QStOazFZNXpUSVFYcW1t?=
 =?utf-8?B?aUtWbWhlZTJpeFlKVk05clFDcENoZWVSdEZyRnVTcWFCTXR6a1VUWDFaQ3Av?=
 =?utf-8?B?N2JkSEtBWXdvbGlibzZ3YlkrSG1MaE5Ub1RvNkdCcUdXdUVDREdIR0V6S001?=
 =?utf-8?B?dThhK2Ztamt4bkVJN3JRV0Vaa0IvODhFdDVSRVRySXQ4TUNwU3pRbjg1UTNx?=
 =?utf-8?B?Z3dGQUc2RzdTR2xsUUZyNHVSV0Q3QTNpVHR3NURCWVdKR1VUL082R3lJY3lz?=
 =?utf-8?B?RFk4WFRGaHYzL00xaFNiRi9DdTlvbXJYMDRRTzY0UWI1NFBXQ1U1ek9nT09Y?=
 =?utf-8?B?L0RLeW80b0NjNzhpbHF3MlFvMWNwNExOeGFpbTNpcFppNjFUQzVPZk0yTWpO?=
 =?utf-8?B?cVdJRndnQXRBa0dzZE1LOUl2eHpwSHRyTEVwK2NJWkM5OGwrbk9GaTRCVGdu?=
 =?utf-8?B?dHIxYzFHem01NXF6dzd3SjcyYzZwWHZENUxXOTNUcW5XQkF2UEZwOE9CVlFL?=
 =?utf-8?B?TkxvcmQzRWhTaUtnTHA1V1pVMGcra3BseUdPQmtLeXFZYno1RjM0ZjBqbVlM?=
 =?utf-8?B?RU50V095MFpwRFRobGpmQUloNmJOZ1JBQ3hreUl2anozZWRyOHBubU1hczNX?=
 =?utf-8?Q?422jnjIEwhmzlujqcts0L/4VAt7uksMr02Xi3QmOM8ELK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-1: WcMs7dvaLZ5vbYhzdLI1YQfjXCMOABvKfC92zPAq2YVZ0vojLaiGjKVJAEdxMGzytns28bLkvpaXnPfS5on6c9t/JnTuhheHFp5/2NyGCxCD0zwgcsRYvagwRVCmbsz8QDngnK32O6gZEwYeqJiVAbA3WcqZa9axQTRMmrdV6KyT5K04b/20mdPn0oEwnbHKNr1CsxfZkA5Knx35fCFvOxZJPqCKd9NGMTDsh+QKrCcIxoIYONgq4vzW7NC18OpMMY2qtvx8p6htEw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23988687-bdd2-4645-e743-08db9cbf3ad7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4531.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 12:08:54.8140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pHpZsFowlZ4UwX00LhYRIfbH6T1G+0fKWnK6UZn74eAoKhXuToe5MosvW4EJqNEujSXKWyvX3Lo1/kRwv8e82/RJxhOhbbfjb4PajCRRcwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-14_07,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308140112
X-Proofpoint-GUID: nqEAud5Jl0MIjUU1Tbpauu7tdVvrlNE4
X-Proofpoint-ORIG-GUID: nqEAud5Jl0MIjUU1Tbpauu7tdVvrlNE4
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Andrew,
I see that the Kconfig refactor KEXEC and CRASH is making its way thru the process, thank you!

 From automated email on Friday, I see that v27 of the crash hotplug series was picked up, thank you!
I have been watching the mm-nonmm-unstable branch and I do wonder when that v27 will show up there? 
It still has v26 which has build issues related to PROC_KCORE.

Thanks!
eric


On 8/12/23 17:05, Andrew Morton wrote:
> 
> The quilt patch titled
>       Subject: kexec: consolidate kexec and crash options into kernel/Kconfig.kexec
> has been removed from the -mm tree.  Its filename was
>       kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
> 
> This patch was dropped because it was merged into the mm-nonmm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Eric DeVolder <eric.devolder@oracle.com>
> Subject: kexec: consolidate kexec and crash options into kernel/Kconfig.kexec
> Date: Wed, 12 Jul 2023 12:15:32 -0400
> 
> Patch series "refactor Kconfig to consolidate KEXEC and CRASH options", v6.
> 
> The Kconfig is refactored to consolidate KEXEC and CRASH options from
> various arch/<arch>/Kconfig files into new file kernel/Kconfig.kexec.
> 
> The Kconfig.kexec is now a submenu titled "Kexec and crash features"
> located under "General Setup".
> 
> The following options are impacted:
> 
>   - KEXEC
>   - KEXEC_FILE
>   - KEXEC_SIG
>   - KEXEC_SIG_FORCE
>   - KEXEC_IMAGE_VERIFY_SIG
>   - KEXEC_BZIMAGE_VERIFY_SIG
>   - KEXEC_JUMP
>   - CRASH_DUMP
> 
> Over time, these options have been copied between Kconfig files and
> are very similar to one another, but with slight differences.
> 
> The following architectures are impacted by the refactor (because of
> use of one or more KEXEC/CRASH options):
> 
>   - arm
>   - arm64
>   - ia64
>   - loongarch
>   - m68k
>   - mips
>   - parisc
>   - powerpc
>   - riscv
>   - s390
>   - sh
>   - x86
> 
> More information:
> 
> In the patch series "crash: Kernel handling of CPU and memory hot
> un/plug"
> 
>   https://lore.kernel.org/lkml/20230503224145.7405-1-eric.devolder@oracle.com/
> 
> the new kernel feature introduces the config option CRASH_HOTPLUG.
> 
> In reviewing, Thomas Gleixner requested that the new config option
> not be placed in x86 Kconfig. Rather the option needs a generic/common
> home. To Thomas' point, the KEXEC and CRASH options have largely been
> duplicated in the various arch/<arch>/Kconfig files, with minor
> differences. This kind of proliferation is to be avoid/stopped.
> 
>   https://lore.kernel.org/lkml/875y91yv63.ffs@tglx/
> 
> To that end, I have refactored the arch Kconfigs so as to consolidate
> the various KEXEC and CRASH options. Generally speaking, this work has
> the following themes:
> 
> - KEXEC and CRASH options are moved into new file kernel/Kconfig.kexec
>    - These items from arch/Kconfig:
>        CRASH_CORE KEXEC_CORE KEXEC_ELF HAVE_IMA_KEXEC
>    - These items from arch/x86/Kconfig form the common options:
>        KEXEC KEXEC_FILE KEXEC_SIG KEXEC_SIG_FORCE
>        KEXEC_BZIMAGE_VERIFY_SIG KEXEC_JUMP CRASH_DUMP
>    - These items from arch/arm64/Kconfig form the common options:
>        KEXEC_IMAGE_VERIFY_SIG
>    - The crash hotplug series appends CRASH_HOTPLUG to Kconfig.kexec
> - The Kconfig.kexec is now a submenu titled "Kexec and crash features"
>    and is now listed in "General Setup" submenu from init/Kconfig.
> - To control the common options, each has a new ARCH_SUPPORTS_<option>
>    option. These gateway options determine whether the common options
>    options are valid for the architecture.
> - To account for the slight differences in the original architecture
>    coding of the common options, each now has a corresponding
>    ARCH_SELECTS_<option> which are used to elicit the same side effects
>    as the original arch/<arch>/Kconfig files for KEXEC and CRASH options.
> 
> An example, 'make menuconfig' illustrating the submenu:
> 
>    > General setup > Kexec and crash features
>    [*] Enable kexec system call
>    [*] Enable kexec file based system call
>    [*]   Verify kernel signature during kexec_file_load() syscall
>    [ ]     Require a valid signature in kexec_file_load() syscall
>    [ ]     Enable bzImage signature verification support
>    [*] kexec jump
>    [*] kernel crash dumps
>    [*]   Update the crash elfcorehdr on system configuration changes
> 
> In the process of consolidating the common options, I encountered
> slight differences in the coding of these options in several of the
> architectures. As a result, I settled on the following solution:
> 
> - Each of the common options has a 'depends on ARCH_SUPPORTS_<option>'
>    statement. For example, the KEXEC_FILE option has a 'depends on
>    ARCH_SUPPORTS_KEXEC_FILE' statement.
> 
>    This approach is needed on all common options so as to prevent
>    options from appearing for architectures which previously did
>    not allow/enable them. For example, arm supports KEXEC but not
>    KEXEC_FILE. The arch/arm/Kconfig does not provide
>    ARCH_SUPPORTS_KEXEC_FILE and so KEXEC_FILE and related options
>    are not available to arm.
> 
> - The boolean ARCH_SUPPORTS_<option> in effect allows the arch to
>    determine when the feature is allowed.  Archs which don't have the
>    feature simply do not provide the corresponding ARCH_SUPPORTS_<option>.
>    For each arch, where there previously were KEXEC and/or CRASH
>    options, these have been replaced with the corresponding boolean
>    ARCH_SUPPORTS_<option>, and an appropriate def_bool statement.
> 
>    For example, if the arch supports KEXEC_FILE, then the
>    ARCH_SUPPORTS_KEXEC_FILE simply has a 'def_bool y'. This permits
>    the KEXEC_FILE option to be available.
> 
>    If the arch has a 'depends on' statement in its original coding
>    of the option, then that expression becomes part of the def_bool
>    expression. For example, arm64 had:
> 
>    config KEXEC
>      depends on PM_SLEEP_SMP
> 
>    and in this solution, this converts to:
> 
>    config ARCH_SUPPORTS_KEXEC
>      def_bool PM_SLEEP_SMP
> 
> 
> - In order to account for the architecture differences in the
>    coding for the common options, the ARCH_SELECTS_<option> in the
>    arch/<arch>/Kconfig is used. This option has a 'depends on
>    <option>' statement to couple it to the main option, and from
>    there can insert the differences from the common option and the
>    arch original coding of that option.
> 
>    For example, a few archs enable CRYPTO and CRYTPO_SHA256 for
>    KEXEC_FILE. These require a ARCH_SELECTS_KEXEC_FILE and
>    'select CRYPTO' and 'select CRYPTO_SHA256' statements.
> 
> Illustrating the option relationships:
> 
> For each of the common KEXEC and CRASH options:
>   ARCH_SUPPORTS_<option> <- <option> <- ARCH_SELECTS_<option>
> 
>   <option>                   # in Kconfig.kexec
>   ARCH_SUPPORTS_<option>     # in arch/<arch>/Kconfig, as needed
>   ARCH_SELECTS_<option>      # in arch/<arch>/Kconfig, as needed
> 
> 
> For example, KEXEC:
>   ARCH_SUPPORTS_KEXEC <- KEXEC <- ARCH_SELECTS_KEXEC
> 
>   KEXEC                      # in Kconfig.kexec
>   ARCH_SUPPORTS_KEXEC        # in arch/<arch>/Kconfig, as needed
>   ARCH_SELECTS_KEXEC         # in arch/<arch>/Kconfig, as needed
> 
> 
> To summarize, the ARCH_SUPPORTS_<option> permits the <option> to be
> enabled, and the ARCH_SELECTS_<option> handles side effects (ie.
> select statements).
> 
> Examples:
> A few examples to show the new strategy in action:
> 
> ===== x86 (minus the help section) =====
> Original:
>   config KEXEC
>      bool "kexec system call"
>      select KEXEC_CORE
> 
>   config KEXEC_FILE
>      bool "kexec file based system call"
>      select KEXEC_CORE
>      select HAVE_IMA_KEXEC if IMA
>      depends on X86_64
>      depends on CRYPTO=y
>      depends on CRYPTO_SHA256=y
> 
>   config ARCH_HAS_KEXEC_PURGATORY
>      def_bool KEXEC_FILE
> 
>   config KEXEC_SIG
>      bool "Verify kernel signature during kexec_file_load() syscall"
>      depends on KEXEC_FILE
> 
>   config KEXEC_SIG_FORCE
>      bool "Require a valid signature in kexec_file_load() syscall"
>      depends on KEXEC_SIG
> 
>   config KEXEC_BZIMAGE_VERIFY_SIG
>      bool "Enable bzImage signature verification support"
>      depends on KEXEC_SIG
>      depends on SIGNED_PE_FILE_VERIFICATION
>      select SYSTEM_TRUSTED_KEYRING
> 
>   config CRASH_DUMP
>      bool "kernel crash dumps"
>      depends on X86_64 || (X86_32 && HIGHMEM)
> 
>   config KEXEC_JUMP
>      bool "kexec jump"
>      depends on KEXEC && HIBERNATION
>      help
> 
> becomes...
> New:
> config ARCH_SUPPORTS_KEXEC
>      def_bool y
> 
> config ARCH_SUPPORTS_KEXEC_FILE
>      def_bool X86_64 && CRYPTO && CRYPTO_SHA256
> 
> config ARCH_SELECTS_KEXEC_FILE
>      def_bool y
>      depends on KEXEC_FILE
>      select HAVE_IMA_KEXEC if IMA
> 
> config ARCH_SUPPORTS_KEXEC_PURGATORY
>      def_bool KEXEC_FILE
> 
> config ARCH_SUPPORTS_KEXEC_SIG
>      def_bool y
> 
> config ARCH_SUPPORTS_KEXEC_SIG_FORCE
>      def_bool y
> 
> config ARCH_SUPPORTS_KEXEC_BZIMAGE_VERIFY_SIG
>      def_bool y
> 
> config ARCH_SUPPORTS_KEXEC_JUMP
>      def_bool y
> 
> config ARCH_SUPPORTS_CRASH_DUMP
>      def_bool X86_64 || (X86_32 && HIGHMEM)
> 
> 
> ===== powerpc (minus the help section) =====
> Original:
>   config KEXEC
>      bool "kexec system call"
>      depends on PPC_BOOK3S || PPC_E500 || (44x && !SMP)
>      select KEXEC_CORE
> 
>   config KEXEC_FILE
>      bool "kexec file based system call"
>      select KEXEC_CORE
>      select HAVE_IMA_KEXEC if IMA
>      select KEXEC_ELF
>      depends on PPC64
>      depends on CRYPTO=y
>      depends on CRYPTO_SHA256=y
> 
>   config ARCH_HAS_KEXEC_PURGATORY
>      def_bool KEXEC_FILE
> 
>   config CRASH_DUMP
>      bool "Build a dump capture kernel"
>      depends on PPC64 || PPC_BOOK3S_32 || PPC_85xx || (44x && !SMP)
>      select RELOCATABLE if PPC64 || 44x || PPC_85xx
> 
> becomes...
> New:
> config ARCH_SUPPORTS_KEXEC
>      def_bool PPC_BOOK3S || PPC_E500 || (44x && !SMP)
> 
> config ARCH_SUPPORTS_KEXEC_FILE
>      def_bool PPC64 && CRYPTO=y && CRYPTO_SHA256=y
> 
> config ARCH_SUPPORTS_KEXEC_PURGATORY
>      def_bool KEXEC_FILE
> 
> config ARCH_SELECTS_KEXEC_FILE
>      def_bool y
>      depends on KEXEC_FILE
>      select KEXEC_ELF
>      select HAVE_IMA_KEXEC if IMA
> 
> config ARCH_SUPPORTS_CRASH_DUMP
>      def_bool PPC64 || PPC_BOOK3S_32 || PPC_85xx || (44x && !SMP)
> 
> config ARCH_SELECTS_CRASH_DUMP
>      def_bool y
>      depends on CRASH_DUMP
>      select RELOCATABLE if PPC64 || 44x || PPC_85xx
> 
> 
> Testing Approach and Results
> 
> There are 388 config files in the arch/<arch>/configs directories.
> For each of these config files, a .config is generated both before and
> after this Kconfig series, and checked for equivalence. This approach
> allows for a rather rapid check of all architectures and a wide
> variety of configs wrt/ KEXEC and CRASH, and avoids requiring
> compiling for all architectures and running kernels and run-time
> testing.
> 
> For each config file, the olddefconfig, allnoconfig and allyesconfig
> targets are utilized. In testing the randconfig has revealed problems
> as well, but is not used in the before and after equivalence check
> since one can not generate the "same" .config for before and after,
> even if using the same KCONFIG_SEED since the option list is
> different.
> 
> As such, the following script steps compare the before and after
> of 'make olddefconfig'. The new symbols introduced by this series
> are filtered out, but otherwise the config files are PASS only if
> they were equivalent, and FAIL otherwise.
> 
> The script performs the test by doing the following:
> 
>   # Obtain the "golden" .config output for given config file
>   # Reset test sandbox
>   git checkout master
>   git branch -D test_Kconfig
>   git checkout -B test_Kconfig master
>   make distclean
>   # Write out updated config
>   cp -f <config file> .config
>   make ARCH=<arch> olddefconfig
>   # Track each item in .config, LHSB is "golden"
>   scoreboard .config
> 
>   # Obtain the "changed" .config output for given config file
>   # Reset test sandbox
>   make distclean
>   # Apply this Kconfig series
>   git am <this Kconfig series>
>   # Write out updated config
>   cp -f <config file> .config
>   make ARCH=<arch> olddefconfig
>   # Track each item in .config, RHSB is "changed"
>   scoreboard .config
> 
>   # Determine test result
>   # Filter-out new symbols introduced by this series
>   # Filter-out symbol=n which not in either scoreboard
>   # Compare LHSB "golden" and RHSB "changed" scoreboards and issue PASS/FAIL
> 
> The script was instrumental during the refactoring of Kconfig as it
> continually revealed problems. The end result being that the solution
> presented in this series passes all configs as checked by the script,
> with the following exceptions:
> 
> - arch/ia64/configs/zx1_config with olddefconfig
>    This config file has:
>    # CONFIG_KEXEC is not set
>    CONFIG_CRASH_DUMP=y
>    and this refactor now couples KEXEC to CRASH_DUMP, so it is not
>    possible to enable CRASH_DUMP without KEXEC.
> 
> - arch/sh/configs/* with allyesconfig
>    The arch/sh/Kconfig codes CRASH_DUMP as dependent upon BROKEN_ON_MMU
>    (which clearly is not meant to be set). This symbol is not provided
>    but with the allyesconfig it is set to yes which enables CRASH_DUMP.
>    But KEXEC is coded as dependent upon MMU, and is set to no in
>    arch/sh/mm/Kconfig, so KEXEC is not enabled.
>    This refactor now couples KEXEC to CRASH_DUMP, so it is not
>    possible to enable CRASH_DUMP without KEXEC.
> 
> While the above exceptions are not equivalent to their original,
> the config file produced is valid (and in fact better wrt/ CRASH_DUMP
> handling).
> 
> 
> This patch (of 14)
> 
> The config options for kexec and crash features are consolidated
> into new file kernel/Kconfig.kexec. Under the "General Setup" submenu
> is a new submenu "Kexec and crash handling". All the kexec and
> crash options that were once in the arch-dependent submenu "Processor
> type and features" are now consolidated in the new submenu.
> 
> The following options are impacted:
> 
>   - KEXEC
>   - KEXEC_FILE
>   - KEXEC_SIG
>   - KEXEC_SIG_FORCE
>   - KEXEC_BZIMAGE_VERIFY_SIG
>   - KEXEC_JUMP
>   - CRASH_DUMP
> 
> The three main options are KEXEC, KEXEC_FILE and CRASH_DUMP.
> 
> Architectures specify support of certain KEXEC and CRASH features with
> similarly named new ARCH_SUPPORTS_<option> config options.
> 
> Architectures can utilize the new ARCH_SELECTS_<option> config
> options to specify additional components when <option> is enabled.
> 
> To summarize, the ARCH_SUPPORTS_<option> permits the <option> to be
> enabled, and the ARCH_SELECTS_<option> handles side effects (ie.
> select statements).
> 
> Link: https://lkml.kernel.org/r/20230712161545.87870-1-eric.devolder@oracle.com
> Link: https://lkml.kernel.org/r/20230712161545.87870-2-eric.devolder@oracle.com
> Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Borislav Petkov (AMD) <bp@alien8.de>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Cc. "H. Peter Anvin" <hpa@zytor.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Dave Hansen <dave.hansen@linux.intel.com> # for x86
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Hari Bathini <hbathini@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: Juerg Haefliger <juerg.haefliger@canonical.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Marc Aurèle La France <tsi@tuyoix.net>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Miguel Ojeda <ojeda@kernel.org>
> Cc: Mike Rapoport (IBM) <rppt@kernel.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Will Deacon <will@kernel.org>
> Cc: Xin Li <xin3.li@intel.com>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Zhen Lei <thunder.leizhen@huawei.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   arch/Kconfig         |   13 ----
>   init/Kconfig         |    2
>   kernel/Kconfig.kexec |  116 +++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 118 insertions(+), 13 deletions(-)
> 
> --- a/arch/Kconfig~kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec
> +++ a/arch/Kconfig
> @@ -11,19 +11,6 @@ source "arch/$(SRCARCH)/Kconfig"
>   
>   menu "General architecture-dependent options"
>   
> -config CRASH_CORE
> -	bool
> -
> -config KEXEC_CORE
> -	select CRASH_CORE
> -	bool
> -
> -config KEXEC_ELF
> -	bool
> -
> -config HAVE_IMA_KEXEC
> -	bool
> -
>   config ARCH_HAS_SUBPAGE_FAULTS
>   	bool
>   	help
> --- a/init/Kconfig~kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec
> +++ a/init/Kconfig
> @@ -1927,6 +1927,8 @@ config BINDGEN_VERSION_TEXT
>   config TRACEPOINTS
>   	bool
>   
> +source "kernel/Kconfig.kexec"
> +
>   endmenu		# General setup
>   
>   source "arch/Kconfig"
> --- /dev/null
> +++ a/kernel/Kconfig.kexec
> @@ -0,0 +1,116 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +menu "Kexec and crash features"
> +
> +config CRASH_CORE
> +	bool
> +
> +config KEXEC_CORE
> +	select CRASH_CORE
> +	bool
> +
> +config KEXEC_ELF
> +	bool
> +
> +config HAVE_IMA_KEXEC
> +	bool
> +
> +config KEXEC
> +	bool "Enable kexec system call"
> +	default ARCH_DEFAULT_KEXEC
> +	depends on ARCH_SUPPORTS_KEXEC
> +	select KEXEC_CORE
> +	help
> +	  kexec is a system call that implements the ability to shutdown your
> +	  current kernel, and to start another kernel. It is like a reboot
> +	  but it is independent of the system firmware. And like a reboot
> +	  you can start any kernel with it, not just Linux.
> +
> +	  The name comes from the similarity to the exec system call.
> +
> +	  It is an ongoing process to be certain the hardware in a machine
> +	  is properly shutdown, so do not be surprised if this code does not
> +	  initially work for you. As of this writing the exact hardware
> +	  interface is strongly in flux, so no good recommendation can be
> +	  made.
> +
> +config KEXEC_FILE
> +	bool "Enable kexec file based system call"
> +	depends on ARCH_SUPPORTS_KEXEC_FILE
> +	select KEXEC_CORE
> +	help
> +	  This is new version of kexec system call. This system call is
> +	  file based and takes file descriptors as system call argument
> +	  for kernel and initramfs as opposed to list of segments as
> +	  accepted by kexec system call.
> +
> +config KEXEC_SIG
> +	bool "Verify kernel signature during kexec_file_load() syscall"
> +	depends on ARCH_SUPPORTS_KEXEC_SIG
> +	depends on KEXEC_FILE
> +	help
> +	  This option makes the kexec_file_load() syscall check for a valid
> +	  signature of the kernel image. The image can still be loaded without
> +	  a valid signature unless you also enable KEXEC_SIG_FORCE, though if
> +	  there's a signature that we can check, then it must be valid.
> +
> +	  In addition to this option, you need to enable signature
> +	  verification for the corresponding kernel image type being
> +	  loaded in order for this to work.
> +
> +config KEXEC_SIG_FORCE
> +	bool "Require a valid signature in kexec_file_load() syscall"
> +	depends on ARCH_SUPPORTS_KEXEC_SIG_FORCE
> +	depends on KEXEC_SIG
> +	help
> +	  This option makes kernel signature verification mandatory for
> +	  the kexec_file_load() syscall.
> +
> +config KEXEC_IMAGE_VERIFY_SIG
> +	bool "Enable Image signature verification support (ARM)"
> +	default ARCH_DEFAULT_KEXEC_IMAGE_VERIFY_SIG
> +	depends on ARCH_SUPPORTS_KEXEC_IMAGE_VERIFY_SIG
> +	depends on KEXEC_SIG
> +	depends on EFI && SIGNED_PE_FILE_VERIFICATION
> +	help
> +	  Enable Image signature verification support.
> +
> +config KEXEC_BZIMAGE_VERIFY_SIG
> +	bool "Enable bzImage signature verification support"
> +	depends on ARCH_SUPPORTS_KEXEC_BZIMAGE_VERIFY_SIG
> +	depends on KEXEC_SIG
> +	depends on SIGNED_PE_FILE_VERIFICATION
> +	select SYSTEM_TRUSTED_KEYRING
> +	help
> +	  Enable bzImage signature verification support.
> +
> +config KEXEC_JUMP
> +	bool "kexec jump"
> +	depends on ARCH_SUPPORTS_KEXEC_JUMP
> +	depends on KEXEC && HIBERNATION
> +	help
> +	  Jump between original kernel and kexeced kernel and invoke
> +	  code in physical address mode via KEXEC
> +
> +config CRASH_DUMP
> +	bool "kernel crash dumps"
> +	depends on ARCH_SUPPORTS_CRASH_DUMP
> +	depends on ARCH_SUPPORTS_KEXEC
> +	select CRASH_CORE
> +	select KEXEC_CORE
> +	select KEXEC
> +	help
> +	  Generate crash dump after being started by kexec.
> +	  This should be normally only set in special crash dump kernels
> +	  which are loaded in the main kernel with kexec-tools into
> +	  a specially reserved region and then later executed after
> +	  a crash by kdump/kexec. The crash dump kernel must be compiled
> +	  to a memory address not used by the main kernel or BIOS using
> +	  PHYSICAL_START, or it must be built as a relocatable image
> +	  (CONFIG_RELOCATABLE=y).
> +	  For more details see Documentation/admin-guide/kdump/kdump.rst
> +
> +	  For s390, this option also enables zfcpdump.
> +	  See also <file:Documentation/s390/zfcpdump.rst>
> +
> +endmenu
> _
> 
> Patches currently in -mm which might be from eric.devolder@oracle.com are
> 
> crash-move-a-few-code-bits-to-setup-support-of-crash-hotplug.patch
> crash-add-generic-infrastructure-for-crash-hotplug-support.patch
> kexec-exclude-elfcorehdr-from-the-segment-digest.patch
> crash-memory-and-cpu-hotplug-sysfs-attributes.patch
> x86-crash-add-x86-crash-hotplug-support.patch
> crash-hotplug-support-for-kexec_load.patch
> crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch
> x86-crash-optimize-cpu-changes.patch
> 
